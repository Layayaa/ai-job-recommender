// 全局变量
let selectedSkills = new Set();

// DOM 加载完成
document.addEventListener('DOMContentLoaded', function() {
    initApp();
});

// 初始化应用
function initApp() {
    // 绑定事件
    bindEvents();

    // 加载所有岗位
    loadAllJobs();

    // 初始化技能标签
    initSkillTags();
}

// 绑定所有事件
function bindEvents() {
    // 搜索按钮
    document.getElementById('search-btn').addEventListener('click', handleSearch);

    // 推荐按钮
    document.getElementById('recommend-btn').addEventListener('click', handleAIRecommend);

    // 搜索输入框回车
    document.getElementById('search-input').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            handleSearch();
        }
    });

    // 技能输入框回车
    document.getElementById('skills-input').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            handleAIRecommend();
        }
    });

    // 城市输入框回车
    document.getElementById('city-input').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            handleAIRecommend();
        }
    });

    // 文件上传变化
    document.getElementById('resume-file').addEventListener('change', handleFileChange);

    // 标签页切换
    const tabButtons = document.querySelectorAll('[data-bs-toggle="tab"]');
    tabButtons.forEach(button => {
        button.addEventListener('shown.bs.tab', handleTabSwitch);
    });
}

// 初始化技能标签
function initSkillTags() {
    const skillTags = document.querySelectorAll('.skill-tag');
    skillTags.forEach(tag => {
        tag.addEventListener('click', function() {
            toggleSkill(this);
        });
    });
}

// 切换技能选择
function toggleSkill(element) {
    const skill = element.textContent.trim();

    if (selectedSkills.has(skill)) {
        selectedSkills.delete(skill);
        element.classList.remove('selected');
    } else {
        selectedSkills.add(skill);
        element.classList.add('selected');
    }
}

// 获取选中的技能数组
function getSelectedSkillsArray() {
    return Array.from(selectedSkills);
}

// 处理文件变化
function handleFileChange(e) {
    const file = e.target.files[0];
    if (file) {
        const fileName = file.name;
        const fileSize = (file.size / 1024).toFixed(2);

        // 更新界面提示
        const fileInput = document.getElementById('resume-file');
        const hint = fileInput.nextElementSibling;
        hint.textContent = `已选择: ${fileName} (${fileSize}KB)`;
        hint.classList.add('text-success');
    }
}

// 处理标签页切换
function handleTabSwitch(e) {
    const activeTab = e.target.getAttribute('data-bs-target');
    console.log('切换到标签页:', activeTab);
}

// 分析简历
async function analyzeResume() {
    const loading = document.getElementById('analyze-loading');
    const fileInput = document.getElementById('resume-file');
    const textArea = document.getElementById('resume-text');

    let resumeContent = '';

    // 获取简历内容
    if (document.querySelector('#upload-tab').classList.contains('active') && fileInput.files.length > 0) {
        const file = fileInput.files[0];
        resumeContent = await readFileAsText(file);
    } else if (document.querySelector('#paste-tab').classList.contains('active')) {
        resumeContent = textArea.value.trim();
    }

    if (!resumeContent) {
        showAlert('请上传简历文件或粘贴简历内容！', 'warning');
        return;
    }

    if (resumeContent.length < 50) {
        showAlert('简历内容过短，请提供更详细的简历信息！', 'warning');
        return;
    }

    // 显示加载
    loading.style.display = 'block';
    showAlert('AI正在分析你的简历，请稍候...', 'info');

    try {
        const response = await fetch('/api/analyze-resume', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                resumeText: resumeContent,
                skills: getSelectedSkillsArray()
            })
        });

        if (!response.ok) {
            const error = await response.text();
            throw new Error(`API错误: ${error}`);
        }

        const data = await response.json();

        if (data.error) {
            throw new Error(data.error);
        }

        // 显示推荐结果
        displayJobRecommendations(data);
        showAlert('简历分析完成！已为您推荐匹配的岗位。', 'success');

    } catch (error) {
        console.error('分析失败:', error);
        showAlert(`简历分析失败: ${error.message}`, 'danger');
    } finally {
        loading.style.display = 'none';
    }
}

// 处理搜索
async function handleSearch() {
    const keyword = document.getElementById('search-input').value.trim();
    if (!keyword) {
        showAlert('请输入搜索关键词', 'warning');
        return;
    }

    try {
        const response = await fetch(`/api/search-jobs?keyword=${encodeURIComponent(keyword)}`);
        if (!response.ok) throw new Error('搜索失败');

        const jobs = await response.json();
        updateJobList(jobs, `搜索"${keyword}"的结果`);
        showAlert(`找到 ${jobs.length} 个相关岗位`, 'info');

    } catch (error) {
        console.error('搜索失败:', error);
        showAlert('搜索失败，请稍后重试', 'danger');
    }
}

// 处理AI推荐
async function handleAIRecommend() {
    const skills = document.getElementById('skills-input').value.trim();
    const city = document.getElementById('city-input').value.trim();

    if (!skills && !city) {
        showAlert('请输入技能或城市', 'warning');
        return;
    }

    try {
        const params = new URLSearchParams();
        if (skills) params.append('skills', skills);
        if (city) params.append('city', city);

        const response = await fetch(`/api/ai-recommend?${params}`);
        if (!response.ok) throw new Error('推荐失败');

        const recommendations = await response.json();
        displayJobRecommendations(recommendations);

        const msg = skills && city ?
            `已根据"${skills}"技能和"${city}"城市为您推荐岗位` :
            skills ? `已根据"${skills}"技能为您推荐岗位` :
                `已根据"${city}"城市为您推荐岗位`;
        showAlert(msg, 'success');

    } catch (error) {
        console.error('推荐失败:', error);
        showAlert('推荐失败，请稍后重试', 'danger');
    }
}

// 加载所有岗位
async function loadAllJobs() {
    try {
        const response = await fetch('/api/jobs');
        if (!response.ok) throw new Error('加载失败');

        const jobs = await response.json();
        displayJobRecommendations(jobs);

    } catch (error) {
        console.error('加载岗位失败:', error);
    }
}

// 显示岗位推荐
function displayJobRecommendations(data) {
    const jobList = document.getElementById('job-list');
    const resultTitle = document.getElementById('result-title');

    // 更新标题
    if (data.candidate_name && data.candidate_name !== '未知') {
        resultTitle.textContent = `${data.candidate_name} 的推荐岗位`;
    } else if (data.search_keyword) {
        resultTitle.textContent = `搜索"${data.search_keyword}"的结果`;
    } else {
        resultTitle.textContent = 'AI 推荐岗位';
    }

    // 清空现有内容
    jobList.innerHTML = '';

    // 检查数据
    if (!data.recommended_jobs || data.recommended_jobs.length === 0) {
        jobList.innerHTML = `
            <div class="col-12 text-center py-5">
                <i class="bi bi-inbox display-1 text-muted"></i>
                <h4 class="mt-3 text-muted">暂无推荐岗位</h4>
                <p class="text-muted">尝试修改搜索条件或上传简历获取更多推荐</p>
            </div>
        `;
        return;
    }

    // 添加每个推荐岗位
    data.recommended_jobs.forEach((job, index) => {
        const score = job.match_score || 0;
        const scoreClass = score >= 80 ? 'score-high' :
            score >= 60 ? 'score-medium' : 'score-low';

        const jobCard = createJobCard(job, scoreClass, index);
        jobList.insertAdjacentHTML('beforeend', jobCard);
    });
}

// 创建岗位卡片
function createJobCard(job, scoreClass, index) {
    const score = job.match_score || 0;
    const delay = index * 100;

    return `
        <div class="col-lg-4 col-md-6 mb-4" style="animation-delay: ${delay}ms">
            <div class="card job-card" style="animation: fadeIn 0.5s">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <h5 class="card-title mb-0" style="flex: 1">${escapeHtml(job.job_title || '未命名岗位')}</h5>
                        ${score > 0 ? `<span class="badge ${scoreClass} badge-score ms-2">${score}分</span>` : ''}
                    </div>
                    
                    ${job.company ? `
                        <p class="card-text text-muted mb-2">
                            <i class="bi bi-building me-2"></i> ${escapeHtml(job.company)}
                        </p>
                    ` : ''}
                    
                    ${job.location ? `
                        <p class="card-text text-muted mb-2">
                            <i class="bi bi-geo-alt me-2"></i> ${escapeHtml(job.location)}
                        </p>
                    ` : ''}
                    
                    ${job.salary ? `
                        <p class="card-text text-muted mb-3">
                            <i class="bi bi-cash me-2"></i> ${escapeHtml(job.salary)}
                        </p>
                    ` : ''}
                    
                    ${job.requirements ? `
                        <div class="mb-3">
                            <small class="text-muted">要求：</small>
                            <p class="mb-0" style="font-size: 0.9rem">${escapeHtml(job.requirements.substring(0, 100))}${job.requirements.length > 100 ? '...' : ''}</p>
                        </div>
                    ` : ''}
                    
                    ${job.reason ? `
                        <div class="bg-light p-3 rounded mb-3">
                            <small class="text-muted d-block mb-1">推荐理由：</small>
                            <p class="mb-0" style="font-size: 0.9rem; line-height: 1.5">${escapeHtml(job.reason)}</p>
                        </div>
                    ` : ''}
                    
                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <small class="text-muted">
                            <i class="bi bi-calendar me-1"></i> ${job.created_at ? formatDate(job.created_at) : '未知'}
                        </small>
                        <button class="btn btn-sm btn-outline-primary" onclick="applyJob(${job.id || index})">
                            申请
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;
}

// 更新岗位列表
function updateJobList(jobs, title) {
    const data = {
        recommended_jobs: jobs,
        search_keyword: title
    };
    displayJobRecommendations(data);
}

// 读取文件为文本
function readFileAsText(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = (e) => resolve(e.target.result);
        reader.onerror = (e) => reject(new Error('文件读取失败'));

        if (file.type.includes('text') || file.name.endsWith('.txt')) {
            reader.readAsText(file, 'UTF-8');
        } else {
            reader.readAsDataURL(file);
        }
    });
}

// 申请岗位
function applyJob(jobId) {
    showAlert(`正在申请岗位 #${jobId}...`, 'info');
    // TODO: 实现申请逻辑
    setTimeout(() => {
        showAlert('申请已提交，HR会尽快联系您！', 'success');
    }, 1500);
}

// 显示提示
function showAlert(message, type = 'info') {
    // 移除现有提示
    const existingAlert = document.querySelector('.custom-alert');
    if (existingAlert) {
        existingAlert.remove();
    }

    const alert = document.createElement('div');
    alert.className = `alert alert-${type} custom-alert alert-dismissible fade show`;
    alert.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        min-width: 300px;
        animation: fadeIn 0.3s;
    `;
    alert.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;

    document.body.appendChild(alert);

    // 3秒后自动消失
    setTimeout(() => {
        if (alert.parentNode) {
            alert.classList.remove('show');
            setTimeout(() => alert.remove(), 300);
        }
    }, 3000);
}

// 格式化日期
function formatDate(dateString) {
    if (!dateString) return '未知';

    try {
        const date = new Date(dateString);
        return date.toLocaleDateString('zh-CN', {
            year: 'numeric',
            month: 'short',
            day: 'numeric'
        });
    } catch (e) {
        return dateString;
    }
}

// HTML 转义
function escapeHtml(text) {
    if (!text) return '';

    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// 刷新页面
function refreshPage() {
    window.location.reload();
}

// 全局导出函数
window.analyzeResume = analyzeResume;
window.refreshPage = refreshPage;
window.applyJob = applyJob;
window.toggleSkill = toggleSkill;