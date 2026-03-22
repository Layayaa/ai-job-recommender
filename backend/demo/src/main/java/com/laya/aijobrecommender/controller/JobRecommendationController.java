package com.laya.aijobrecommender.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.CrossOrigin;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class JobRecommendationController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final DateTimeFormatter DATE_FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd");

    // 1. 搜索岗位 - 完全匹配你的表结构
    @GetMapping("/search-jobs")
    public SearchResponse searchJobs(@RequestParam String keyword) {
        System.out.println("🔍 搜索关键词: " + keyword);

        // SQL查询 - 使用正确的字段名 'title'
        String sql = "SELECT * FROM jobs WHERE " +
                "title LIKE ? OR " +
                "company LIKE ? OR " +
                "location LIKE ? OR " +
                "requirements LIKE ? OR " +
                "description LIKE ? " +
                "ORDER BY created_at DESC";

        String searchPattern = "%" + keyword + "%";
        List<Map<String, Object>> results = jdbcTemplate.queryForList(
                sql, searchPattern, searchPattern, searchPattern,
                searchPattern, searchPattern
        );

        System.out.println("✅ 找到 " + results.size() + " 个匹配岗位");

        // 转换为前端需要的格式
        List<SearchResponse.JobInfo> jobInfos = new ArrayList<>();
        for (Map<String, Object> row : results) {
            jobInfos.add(new SearchResponse.JobInfo(
                    getStringValue(row, "title", ""),  // 使用 'title'
                    calculateMatchScore(row, keyword),
                    generateSearchReason(row, keyword),
                    getStringValue(row, "company", ""),
                    getStringValue(row, "location", ""),
                    generateSalaryEstimate(row),  // 生成预估薪资
                    getStringValue(row, "requirements", ""),
                    formatDate(getStringValue(row, "created_at", ""))
            ));
        }

        return new SearchResponse("搜索用户", jobInfos);
    }

    // 2. 获取所有岗位
    @GetMapping("/jobs")
    public SearchResponse getAllJobs() {
        String sql = "SELECT * FROM jobs ORDER BY created_at DESC";
        List<Map<String, Object>> results = jdbcTemplate.queryForList(sql);

        System.out.println("📊 加载所有岗位: " + results.size() + " 个");

        List<SearchResponse.JobInfo> jobInfos = new ArrayList<>();
        for (Map<String, Object> row : results) {
            jobInfos.add(new SearchResponse.JobInfo(
                    getStringValue(row, "title", ""),
                    0,  // 无匹配分数
                    "系统推荐岗位",
                    getStringValue(row, "company", ""),
                    getStringValue(row, "location", ""),
                    generateSalaryEstimate(row),  // 生成预估薪资
                    getStringValue(row, "requirements", ""),
                    formatDate(getStringValue(row, "created_at", ""))
            ));
        }

        return new SearchResponse("系统推荐", jobInfos);
    }

    // 3. AI智能推荐（根据技能和城市）
    @GetMapping("/ai-recommend")
    public SearchResponse aiRecommend(@RequestParam(required = false) String skills,
                                      @RequestParam(required = false) String city) {
        System.out.println("🤖 AI推荐请求 - 技能: " + skills + ", 城市: " + city);

        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM jobs WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (skills != null && !skills.trim().isEmpty()) {
            sqlBuilder.append(" AND requirements LIKE ?");
            params.add("%" + skills + "%");
        }

        if (city != null && !city.trim().isEmpty()) {
            sqlBuilder.append(" AND location LIKE ?");
            params.add("%" + city + "%");
        }

        sqlBuilder.append(" ORDER BY created_at DESC");

        List<Map<String, Object>> results = jdbcTemplate.queryForList(
                sqlBuilder.toString(), params.toArray()
        );

        System.out.println("✅ AI推荐找到 " + results.size() + " 个匹配岗位");

        List<SearchResponse.JobInfo> jobInfos = new ArrayList<>();
        for (Map<String, Object> row : results) {
            int matchScore = calculateAIRecommendationScore(row, skills, city);

            jobInfos.add(new SearchResponse.JobInfo(
                    getStringValue(row, "title", ""),
                    matchScore,
                    generateAIRecommendationReason(row, skills, city),
                    getStringValue(row, "company", ""),
                    getStringValue(row, "location", ""),
                    generateSalaryEstimate(row),  // 生成预估薪资
                    getStringValue(row, "requirements", ""),
                    formatDate(getStringValue(row, "created_at", ""))
            ));
        }

        return new SearchResponse("AI推荐", jobInfos);
    }

    // 4. 简历分析接口（保持原有逻辑）
    @PostMapping("/analyze-resume")
    public SearchResponse analyzeResume(@RequestBody ResumeAnalysisRequest request) {
        System.out.println("📄 收到简历分析请求");
        System.out.println("简历内容长度: " + request.getResumeText().length());
        System.out.println("技能: " + String.join(", ", request.getSkills()));

        // 这里可以添加简历分析逻辑，调用Dify工作流等
        // 暂时返回模拟数据

        List<SearchResponse.JobInfo> jobInfos = new ArrayList<>();
        jobInfos.add(new SearchResponse.JobInfo(
                "Java后端开发实习生",
                85,
                "技能匹配度高，简历中的Java、Spring Boot与岗位要求相符",
                "字节跳动",
                "北京",
                "300-500元/天",
                "熟悉Java基础，熟练使用Spring Boot、MyBatis框架",
                LocalDateTime.now().format(DATE_FORMATTER)
        ));

        return new SearchResponse("张三", jobInfos);
    }

    // ========== 辅助方法 ==========

    // 安全获取字符串值
    private String getStringValue(Map<String, Object> row, String key, String defaultValue) {
        Object value = row.get(key);
        return value != null ? value.toString().trim() : defaultValue;
    }

    // 计算搜索匹配分数
    private int calculateMatchScore(Map<String, Object> job, String keyword) {
        int score = 0;
        String lowerKeyword = keyword.toLowerCase();

        String title = getStringValue(job, "title", "").toLowerCase();
        String company = getStringValue(job, "company", "").toLowerCase();
        String requirements = getStringValue(job, "requirements", "").toLowerCase();

        if (title.contains(lowerKeyword)) score += 50;
        if (company.contains(lowerKeyword)) score += 30;
        if (requirements.contains(lowerKeyword)) score += 20;

        return Math.min(score, 100);
    }

    // 计算AI推荐分数
    private int calculateAIRecommendationScore(Map<String, Object> job, String skills, String city) {
        int score = 0;

        if (skills != null && !skills.trim().isEmpty()) {
            String lowerSkills = skills.toLowerCase();
            String lowerRequirements = getStringValue(job, "requirements", "").toLowerCase();
            if (lowerRequirements.contains(lowerSkills)) score += 60;
        }

        if (city != null && !city.trim().isEmpty()) {
            String lowerCity = city.toLowerCase();
            String lowerLocation = getStringValue(job, "location", "").toLowerCase();
            if (lowerLocation.contains(lowerCity)) score += 40;
        }

        return Math.min(score, 100);
    }

    // 生成搜索推荐理由
    private String generateSearchReason(Map<String, Object> job, String keyword) {
        String title = getStringValue(job, "title", "");
        String company = getStringValue(job, "company", "");
        return "匹配关键词 '" + keyword + "'，岗位：" + title + "，公司：" + company;
    }

    // 生成AI推荐理由
    private String generateAIRecommendationReason(Map<String, Object> job, String skills, String city) {
        StringBuilder reason = new StringBuilder("推荐理由：");

        if (skills != null && !skills.trim().isEmpty()) {
            reason.append("您的技能'").append(skills).append("'与岗位要求匹配。");
        }

        if (city != null && !city.trim().isEmpty()) {
            reason.append(" 工作地点在'").append(city).append("'。");
        }

        String title = getStringValue(job, "title", "");
        reason.append(" 岗位：").append(title);

        return reason.toString();
    }

    // 生成预估薪资（你的表中没有salary字段，所以需要生成）
    private String generateSalaryEstimate(Map<String, Object> job) {
        String location = getStringValue(job, "location", "");
        String title = getStringValue(job, "title", "");
        String requirements = getStringValue(job, "requirements", "");

        // 根据城市、岗位类型生成预估薪资
        if (location.contains("北京") || location.contains("上海") ||
                location.contains("深圳") || location.contains("广州")) {
            return "300-600元/天";
        } else if (location.contains("杭州") || location.contains("南京") ||
                location.contains("成都") || location.contains("武汉")) {
            return "250-500元/天";
        } else {
            return "200-400元/天";
        }
    }

    // 格式化日期
    private String formatDate(String dateStr) {
        if (dateStr == null || dateStr.isEmpty()) {
            return "未知";
        }
        try {
            // 从 "2026-03-14 20:02:58" 格式化为 "2026-03-14"
            return dateStr.substring(0, 10);
        } catch (Exception e) {
            return dateStr;
        }
    }

    // ========== 内部类 ==========

    // 搜索响应类
    public static class SearchResponse {
        private String candidate_name;
        private List<JobInfo> recommended_jobs;

        public SearchResponse(String candidate_name, List<JobInfo> recommended_jobs) {
            this.candidate_name = candidate_name;
            this.recommended_jobs = recommended_jobs;
        }

        public String getCandidate_name() { return candidate_name; }
        public void setCandidate_name(String candidate_name) { this.candidate_name = candidate_name; }
        public List<JobInfo> getRecommended_jobs() { return recommended_jobs; }
        public void setRecommended_jobs(List<JobInfo> recommended_jobs) { this.recommended_jobs = recommended_jobs; }

        // 岗位信息类
        public static class JobInfo {
            private String job_title;      // 对应数据库的 'title' 字段
            private int match_score;
            private String reason;
            private String company;
            private String location;
            private String salary;         // 数据库没有，动态生成
            private String requirements;
            private String created_at;

            public JobInfo(String job_title, int match_score, String reason, String company,
                           String location, String salary, String requirements, String created_at) {
                this.job_title = job_title;
                this.match_score = match_score;
                this.reason = reason;
                this.company = company;
                this.location = location;
                this.salary = salary;
                this.requirements = requirements;
                this.created_at = created_at;
            }

            // Getter 和 Setter
            public String getJob_title() { return job_title; }
            public void setJob_title(String job_title) { this.job_title = job_title; }
            public int getMatch_score() { return match_score; }
            public void setMatch_score(int match_score) { this.match_score = match_score; }
            public String getReason() { return reason; }
            public void setReason(String reason) { this.reason = reason; }
            public String getCompany() { return company; }
            public void setCompany(String company) { this.company = company; }
            public String getLocation() { return location; }
            public void setLocation(String location) { this.location = location; }
            public String getSalary() { return salary; }
            public void setSalary(String salary) { this.salary = salary; }
            public String getRequirements() { return requirements; }
            public void setRequirements(String requirements) { this.requirements = requirements; }
            public String getCreated_at() { return created_at; }
            public void setCreated_at(String created_at) { this.created_at = created_at; }
        }
    }

    // 简历分析请求体
    static class ResumeAnalysisRequest {
        private String resumeText;
        private String[] skills;

        public String getResumeText() { return resumeText; }
        public void setResumeText(String resumeText) { this.resumeText = resumeText; }
        public String[] getSkills() { return skills; }
        public void setSkills(String[] skills) { this.skills = skills; }
    }
}