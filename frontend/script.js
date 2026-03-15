// AI 实习推荐系统前端脚本
// 后端 API 基础地址
const API_BASE_URL = 'http://localhost:8080/api';

// DOM 加载完成后初始化页面
document.addEventListener('DOMContentLoaded', () => {
    console.log('🚀 系统初始化...');

    // 加载所有岗位
    loadAllJobs();

    // 绑定搜索按钮事件
    document.getElementById('search-btn').addEventListener('click', searchJobs);

    // 绑定 AI 推荐按钮事件
    document.getElementById('recommend-btn').addEventListener('click', getAIRecommendations);
});

/**
 * 加载所有岗位
 */
async function loadAllJobs() {
    const jobList = document.getElementById('job-list');

    // 显示加载状态
    jobList.innerHTML = `
        <div class="text-center py-4">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">加载中...</span>
            </div>
            <p class="text-muted mt-2">正在加载岗位信息...</p>
        </div>
    `;

    try {
        const response = await fetch(`${API_BASE_URL}/jobs`);

        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }

        const jobs = await response.json();
        displayJobs(jobs, '所有岗位');
    } catch (error) {
        console.error('❌ 加载岗位失败:', error);
        jobList.innerHTML = `
            <div class="alert alert-danger">
                <h5>加载失败</h5>
                <p>${error.message}</p>
                <button class="btn btn-sm btn-outline-primary" onclick="loadAllJobs()">重试</button>
            </div>
        `;
    }
}

/**
 * 显示岗位列表
 */
function displayJobs(jobs, title = '岗位列表') {
    const jobList = document.getElementById('job-list');
    const resultTitle = document.getElementById('result-title');

    // 更新标题
    if (resultTitle) {
        resultTitle.textContent = title;
    }

    if (!jobs || jobs.length === 0) {
        jobList.innerHTML = `
            <div class="alert alert-info">
                <h5>暂无数据</h5>
                <p>没有找到符合条件的岗位，请尝试其他筛选条件。</p>
            </div>
        `;
        return;
    }

    // 生成岗位卡片
    jobList.innerHTML = jobs.map(job => `
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card job-card h-100">
                <div class="card-body">
                    <h5 class="card-title text-primary">${job.title || '未命名岗位'}</h5>
                    <div class="mb-2">
                        <span class="badge bg-secondary">${job.company || '未知公司'}</span>
                        <span class="badge bg-light text-dark ms-1">${job.location || '未知地点'}</span>
                    </div>
                    <p class="card-text text-muted small">${job.description || '暂无详细描述'}</p>
                    
                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <div>
                            ${job.requirements ? `
                                <span class="badge bg-info me-1">${job.requirements.split(',')[0]}</span>
                            ` : ''}
                        </div>
                        <small class="text-muted">ID: ${job.id || 'N/A'}</small>
                    </div>
                    
                    <div class="mt-3">
                        <button class="btn btn-sm btn-outline-primary me-2" onclick="viewJobDetail(${job.id})">
                            <i class="bi bi-eye"></i> 查看
                        </button>
                        <button class="btn btn-sm btn-outline-success" onclick="recommendThisJob(${job.id})">
                            <i class="bi bi-star"></i> 收藏
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `).join('');
}

/**
 * 搜索岗位
 */
async function searchJobs() {
    const keyword = document.getElementById('search-input').value.trim();
    const jobList = document.getElementById('job-list');

    jobList.innerHTML = `
        <div class="text-center py-4">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">搜索中...</span>
            </div>
            <p class="text-muted mt-2">正在搜索 "${keyword}"...</p>
        </div>
    `;

    try {
        const response = await fetch(`${API_BASE_URL}/jobs/search?keyword=${encodeURIComponent(keyword)}`);
        if (!response.ok) {
            throw new Error(`搜索失败: ${response.status}`);
        }
        const jobs = await response.json();
        displayJobs(jobs, `搜索结果: ${keyword || '所有岗位'}`);
    } catch (error) {
        console.error('搜索失败:', error);
        // 如果后端没有搜索接口，回退到前端过滤
        const response = await fetch(`${API_BASE_URL}/jobs`);
        const allJobs = await response.json();
        const filtered = allJobs.filter(job =>
            !keyword ||
            (job.title && job.title.includes(keyword)) ||
            (job.description && job.description.includes(keyword))
        );
        displayJobs(filtered, `搜索结果: ${keyword || '所有岗位'}`);
    }
}

/**
 * 获取 AI 推荐
 */
async function getAIRecommendations() {
    const skills = document.getElementById('skills-input').value.trim();
    const city = document.getElementById('city-input').value.trim();
    const jobList = document.getElementById('job-list');

    if (!skills) {
        alert('请输入你的技能关键词');
        return;
    }

    jobList.innerHTML = `
        <div class="text-center py-4">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">AI 推荐中...</span>
            </div>
            <p class="text-muted mt-2">🧠 AI 正在分析你的技能: ${skills}...</p>
        </div>
    `;

    try {
        // TODO: 调用你的 Dify 推荐接口
        // 临时先用搜索代替
        const response = await fetch(`${API_BASE_URL}/jobs`);
        const allJobs = await response.json();

        // 简单的前端过滤（后期替换为 AI 接口调用）
        const filtered = allJobs.filter(job => {
            const matchSkill = !skills ||
                (job.requirements && job.requirements.toLowerCase().includes(skills.toLowerCase())) ||
                (job.title && job.title.toLowerCase().includes(skills.toLowerCase()));
            const matchCity = !city || (job.location && job.location.includes(city));
            return matchSkill && matchCity;
        });

        displayJobs(filtered, `AI 推荐: ${skills} ${city ? '在 ' + city : ''}`);

    } catch (error) {
        console.error('AI 推荐失败:', error);
        jobList.innerHTML = `
            <div class="alert alert-warning">
                <h5>AI 推荐功能开发中</h5>
                <p>后端推荐接口尚未实现，请先使用搜索功能。</p>
                <button class="btn btn-sm btn-outline-primary" onclick="loadAllJobs()">返回所有岗位</button>
            </div>
        `;
    }
}

/**
 * 查看岗位详情
 */
async function viewJobDetail(jobId) {
    try {
        const response = await fetch(`${API_BASE_URL}/jobs/${jobId}`);
        if (!response.ok) throw new Error('岗位不存在');
        const job = await response.json();

        // 弹窗显示详情
        alert(`
            🏢 公司: ${job.company || '未知'}
            📌 职位: ${job.title || '未知'}
            📍 地点: ${job.location || '未知'}
            📄 要求: ${job.requirements || '暂无'}
            📋 描述: ${job.description || '暂无'}
        `);
    } catch (error) {
        alert('获取岗位详情失败: ' + error.message);
    }
}

/**
 * 收藏岗位
 */
async function recommendThisJob(jobId) {
    // TODO: 实现收藏功能
    alert(`已收藏岗位 #${jobId}（收藏功能开发中）`);
}

/**
 * 刷新页面
 */
function refreshPage() {
    window.location.reload();
}

/**
 * 导出岗位数据
 */
function exportJobs() {
    fetch(`${API_BASE_URL}/jobs`)
        .then(response => response.json())
        .then(jobs => {
            const dataStr = JSON.stringify(jobs, null, 2);
            const blob = new Blob([dataStr], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'jobs_export.json';
            a.click();
        })
        .catch(error => {
            alert('导出失败: ' + error.message);
        });
}