-- 创建 jobs 表（如果不存在）
CREATE TABLE IF NOT EXISTS jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    company VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    requirements TEXT,
    source_url VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 检查是否已有数据，如果没有则插入示例数据
INSERT INTO jobs (title, description, company, location, requirements) 
SELECT 'Java后端开发实习生', '负责后端系统开发和维护，使用Spring Boot框架', '字节跳动', '北京', 'Java, Spring Boot, MySQL, 熟悉RESTful API' 
WHERE NOT EXISTS (SELECT 1 FROM jobs WHERE title = 'Java后端开发实习生');

INSERT INTO jobs (title, description, company, location, requirements) 
SELECT 'Python开发实习生', '参与AI模型训练和部署', '百度', '北京', 'Python, TensorFlow, 机器学习基础' 
WHERE NOT EXISTS (SELECT 1 FROM jobs WHERE title = 'Python开发实习生');

INSERT INTO jobs (title, description, company, location, requirements) 
SELECT '前端开发实习生', '负责Web前端开发', '腾讯', '深圳', 'HTML, CSS, JavaScript, Vue.js' 
WHERE NOT EXISTS (SELECT 1 FROM jobs WHERE title = '前端开发实习生');

INSERT INTO jobs (title, description, company, location, requirements) 
SELECT '产品经理实习生', '参与产品规划和用户研究', '阿里巴巴', '杭州', '市场分析, 用户研究, 产品设计' 
WHERE NOT EXISTS (SELECT 1 FROM jobs WHERE title = '产品经理实习生');

INSERT INTO jobs (title, description, company, location, requirements) 
SELECT '数据分析师实习生', '负责数据处理和分析', '美团', '北京', 'SQL, Python, 数据可视化' 
WHERE NOT EXISTS (SELECT 1 FROM jobs WHERE title = '数据分析师实习生');

-- 添加用户提供的岗位数据
INSERT INTO jobs (title, company, location, requirements, description, source_url) VALUES
('Java开发工程师', '阿里巴巴', '杭州', '熟悉Java基础，熟练使用Spring Boot、MyBatis框架', '负责电商平台支付系统开发和维护，参与高并发场景优化', 'https://www.alibaba.com/job/java-dev'),
('前端开发工程师', '字节跳动', '北京', '熟悉Vue.js或React，熟练掌握HTML/CSS/JavaScript', '参与抖音短视频平台前端开发，负责用户界面交互优化', 'https://jobs.bytedance.com/frontend-dev'),
('Python开发工程师', '腾讯', '深圳', '熟练使用Python，熟悉Django或Flask框架', '负责微信小程序后端服务开发，参与API接口设计', 'https://careers.tencent.com/python-dev'),
('全栈工程师', '美团', '上海', '熟悉Node.js和React，了解MongoDB数据库', '独立负责外卖平台的全栈开发，前后端一体化开发', 'https://jobs.meituan.com/fullstack-dev'),
('算法工程师', '百度', '北京', '熟悉Python，熟练使用TensorFlow或PyTorch', '负责搜索引擎算法优化，提升搜索结果准确度', 'https://talent.baidu.com/algorithm-dev'),
('数据分析师', '京东', '北京', '熟练使用SQL和Python，了解数据可视化工具', '分析用户行为数据，为业务决策提供数据支持', 'https://zhaopin.jd.com/data-analyst'),
('DevOps工程师', '华为', '深圳', '熟悉Docker和Kubernetes，了解CI/CD流程', '负责CI/CD流水线搭建和维护，提升开发部署效率', 'https://career.huawei.com/devops-engineer'),
('移动端开发工程师', '小米', '北京', '熟悉Kotlin或Swift，了解React Native', '负责MIUI应用开发和优化，参与跨平台方案设计', 'https://hr.xiaomi.com/mobile-dev'),
('大数据工程师', '网易', '杭州', '熟悉Hadoop和Spark，了解数据仓库设计', '负责网易云音乐数据处理平台，参与数据架构设计', 'https://hr.163.com/bigdata-dev'),
('云计算工程师', '亚马逊', '北京', '熟悉AWS或Azure，了解容器化和微服务', '负责云资源管理和自动化部署，优化云服务成本', 'https://www.amazon.jobs/cloud-engineer'),
('网络安全工程师', '360', '北京', '熟悉渗透测试和防火墙配置，了解加密算法', '负责企业安全防护体系建设，定期进行安全审计', 'https://jobs.360.cn/security-engineer'),
('数据库管理员', '工商银行', '北京', '熟悉Oracle和MySQL，了解数据库备份恢复', '负责银行核心数据库管理，确保数据安全和性能', 'https://job.icbc.com.cn/dba'),
('机器学习工程师', '科大讯飞', '合肥', '熟悉Python和Scikit-learn，了解NLP技术', '负责语音识别算法研发，提升识别准确率', 'https://www.iflytek.com/ml-engineer'),
('测试工程师', '拼多多', '上海', '熟悉Selenium和JUnit，了解自动化测试', '负责电商平台功能测试，搭建自动化测试框架', 'https://jobs.pinduoduo.com/test-engineer'),
('UI/UX设计师', '腾讯', '深圳', '熟悉Figma或Sketch，了解用户体验设计', '负责社交产品界面设计，提升用户交互体验', 'https://careers.tencent.com/ui-ux-designer'),
('嵌入式开发工程师', '大疆', '深圳', '熟悉C和C++，了解RTOS和硬件调试', '负责无人机飞控系统开发，优化飞行控制系统', 'https://we.dji.com/embedded-dev'),
('产品经理', '美团', '北京', '熟悉产品方法论，了解数据分析工具', '负责外卖产品规划，协调开发团队推进项目', 'https://jobs.meituan.com/product-manager'),
('架构师', '蚂蚁集团', '杭州', '熟悉微服务架构，了解高并发系统设计', '负责支付系统架构设计，解决核心技术难题', 'https://job.antgroup.com/architect'),
('运维工程师', '58同城', '北京', '熟悉Linux和Shell，了解监控工具', '负责服务器运维和故障处理，保障系统稳定运行', 'https://jobs.58.com/ops-engineer'),
('游戏开发工程师', '米哈游', '上海', '熟悉Unity和C#，了解游戏引擎原理', '负责游戏客户端开发，实现核心游戏玩法', 'https://jobs.mihoyo.com/game-dev'),
('区块链工程师', '火币', '北京', '熟悉Solidity和智能合约，了解Web3技术', '负责去中心化交易所开发，优化区块链性能', 'https://www.huobi.jobs/blockchain-engineer'),
('人工智能研究员', '商汤科技', '北京', '熟悉深度学习和计算机视觉', '负责AI前沿技术研究，发表高水平论文', 'https://jobs.sensetime.com/ai-researcher'),
('技术总监', '滴滴出行', '北京', '具备技术管理经验，了解团队建设', '负责技术研发团队管理，制定技术发展战略', 'https://www.didiglobal.com/tech-director'),
('后端开发工程师', '贝壳找房', '北京', '熟悉Java和Spring Cloud，了解MySQL优化', '负责房产交易平台后端开发，参与系统架构设计', 'https://jobs.ke.com/backend-dev'),
('SAP顾问', 'IBM', '上海', '熟悉SAP系统，了解ABAP开发', '负责企业SAP系统实施，提供业务解决方案', 'https://www.ibm.com/careers/sap-consultant'),
('iOS开发工程师', '网易', '杭州', '熟悉Swift和Objective-C，了解iOS开发规范', '负责音乐App iOS端开发，优化用户体验', 'https://hr.163.com/ios-dev'),
('Android开发工程师', '快手', '北京', '熟悉Kotlin和Java，了解Android SDK', '负责短视频App Android端开发，提升应用性能', 'https://zhaopin.kuaishou.com/android-dev'),
('数据仓库工程师', '携程', '上海', '熟悉Hive和Spark，了解数据建模', '负责旅游行业数据仓库建设，支持业务数据分析', 'https://jobs.ctrip.com/data-warehouse'),
('系统工程师', '平安集团', '深圳', '熟悉Linux和虚拟化技术', '负责金融系统运维，保障系统高可用性', 'https://career.pingan.com/system-engineer'),
('机器视觉工程师', '海康威视', '杭州', '熟悉OpenCV和深度学习', '负责智能安防算法研发，提升监控识别能力', 'https://jobs.hikvision.com/computer-vision'),
('技术支持工程师', '甲骨文', '北京', '熟悉数据库和客户沟通', '负责企业数据库技术支持，解决客户技术问题', 'https://www.oracle.com/careers/tech-support'),
('项目经理', '中兴通讯', '深圳', '熟悉项目管理流程，具备沟通协调能力', '负责通信项目交付，协调各方资源推进项目', 'https://www.zte.com.cn/careers/project-manager'),
('中间件开发工程师', '阿里巴巴', '杭州', '熟悉Java和分布式系统', '负责中间件研发，提升系统性能和稳定性', 'https://www.alibaba.com/job/middleware-dev'),
('推荐算法工程师', '今日头条', '北京', '熟悉机器学习和推荐系统', '负责内容推荐算法优化，提升用户粘性', 'https://jobs.toutiao.com/recommendation-engineer'),
('ERP开发工程师', '用友', '北京', '熟悉Java和ERP系统', '负责企业ERP系统开发，满足客户业务需求', 'https://www.yonyou.com/careers/erp-dev'),
('网络工程师', '中国移动', '北京', '熟悉路由器和交换机配置', '负责企业网络维护，保障网络稳定运行', 'https://10086.cn/careers/network-engineer'),
('虚拟现实工程师', 'Pico', '北京', '熟悉Unity和C#，了解VR开发', '负责VR内容平台开发，提升沉浸式体验', 'https://www.pico-interactive.com/vr-engineer'),
('数据治理工程师', '中国银行', '北京', '熟悉数据质量管理和数据标准', '负责银行数据治理体系建设，提升数据质量', 'https://www.boc.cn/careers/data-governance'),
('自动化测试工程师', '阿里巴巴', '杭州', '熟悉Python和Appium', '负责电商自动化测试平台搭建', 'https://www.alibaba.com/job/auto-test-engineer'),
('Golang开发工程师', '字节跳动', '北京', '熟悉Go语言，了解微服务架构', '负责高并发服务开发，优化系统性能', 'https://jobs.bytedance.com/golang-dev'),
('语音识别工程师', '科大讯飞', '合肥', '熟悉深度学习和Kaldi', '负责语音识别模型训练', 'https://www.iflytek.com/speech-recognition'),
('技术文档工程师', '腾讯', '深圳', '熟悉技术写作和API文档', '负责云产品技术文档编写', 'https://careers.tencent.com/tech-writer'),
('实时计算工程师', '阿里云', '杭州', '熟悉Flink和Kafka', '负责实时数据流处理', 'https://jobs.aliyun.com/realtime-computing'),
('物联网工程师', '小米', '北京', '熟悉IoT协议和MQTT', '负责智能家居设备开发', 'https://hr.xiaomi.com/iot-engineer'),
('SaaS产品经理', '金蝶', '深圳', '熟悉SaaS产品模式', '负责企业SaaS产品规划', 'https://www.kingdee.com/careers/saas-product-manager'),
('图形渲染工程师', '英伟达', '上海', '熟悉OpenGL和Vulkan', '负责显卡驱动渲染优化', 'https://www.nvidia.com/careers/graphics-rendering'),
('首席技术官', '小红书', '北京', '具备技术战略和团队管理经验', '负责公司整体技术战略制定', 'https://www.xiaohongshu.com/careers/cto'),
('隐私安全工程师', '华为', '深圳', '熟悉隐私计算和联邦学习', '负责用户隐私保护技术', 'https://career.huawei.com/privacy-security');
