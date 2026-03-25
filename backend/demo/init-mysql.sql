-- 创建数据库
CREATE DATABASE IF NOT EXISTS ai_job_recommender CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE ai_job_recommender;

-- 创建jobs表
CREATE TABLE IF NOT EXISTS jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL COMMENT '岗位标题',
    company VARCHAR(255) NOT NULL COMMENT '公司名称',
    location VARCHAR(255) NOT NULL COMMENT '工作地点',
    requirements TEXT COMMENT '岗位要求',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入模拟数据
INSERT INTO jobs (title, company, location, requirements, created_at) VALUES
('Java开发工程师', '阿里巴巴', '杭州', '熟悉Java基础，熟练使用Spring Boot、MyBatis框架', '2026-03-22 10:00:00'),
('前端开发工程师', '字节跳动', '北京', '熟悉Vue.js或React，熟练掌握HTML/CSS/JavaScript', '2026-03-21 15:30:00'),
('Python开发工程师', '腾讯', '深圳', '熟练使用Python，熟悉Django或Flask框架', '2026-03-20 09:15:00'),
('产品经理', '美团', '上海', '有互联网产品经验，熟悉产品设计流程', '2026-03-19 14:45:00'),
('UI设计师', '百度', '北京', '熟练使用Figma、Sketch等设计工具', '2026-03-18 11:20:00');

-- 查看插入的数据
SELECT * FROM jobs;
