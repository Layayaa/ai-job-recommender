@echo off
echo ==========================================
echo    启动后端服务（详细模式）
echo ==========================================
echo.

REM 检查当前目录
echo [信息] 当前目录: %CD%
echo.

REM 检查Java是否安装
echo [信息] 检查Java版本...
java -version
echo.

REM 检查Maven包装器
echo [信息] 检查Maven包装器...
if exist mvnw.cmd (
    echo [成功] Maven包装器存在
) else (
    echo [错误] Maven包装器不存在
    pause
    exit /b 1
)
echo.

REM 检查MySQL服务
echo [信息] 检查MySQL服务状态...
sc query MySQL80 | findstr "STATE"
echo.

REM 检查数据库连接
echo [信息] 检查数据库连接...
mysql -u root -p123456 -e "SELECT VERSION();" 2>&1 | findstr "Server version"
if errorlevel 1 (
    echo [错误] 无法连接到MySQL数据库
    echo [信息] 请确保MySQL服务已启动，且密码正确
    pause
    exit /b 1
) else (
    echo [成功] 数据库连接正常
)
echo.

REM 检查数据库和表
echo [信息] 检查数据库和表...
mysql -u root -p123456 -e "USE ai_job_recommender; SHOW TABLES LIKE 'jobs';" 2>&1 | findstr "jobs"
if errorlevel 1 (
    echo [信息] 数据库或表不存在，正在创建...
    mysql -u root -p123456 -e "CREATE DATABASE IF NOT EXISTS ai_job_recommender CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -u root -p123456 -e "USE ai_job_recommender; CREATE TABLE IF NOT EXISTS jobs (id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(255) NOT NULL, company VARCHAR(255) NOT NULL, location VARCHAR(255) NOT NULL, requirements TEXT, created_at DATETIME DEFAULT CURRENT_TIMESTAMP);"
    mysql -u root -p123456 -e "USE ai_job_recommender; INSERT INTO jobs (title, company, location, requirements, created_at) VALUES ('Java开发工程师', '阿里巴巴', '杭州', '熟悉Java基础，熟练使用Spring Boot、MyBatis框架', '2026-03-22 10:00:00'), ('前端开发工程师', '字节跳动', '北京', '熟悉Vue.js或React，熟练掌握HTML/CSS/JavaScript', '2026-03-21 15:30:00'), ('Python开发工程师', '腾讯', '深圳', '熟练使用Python，熟悉Django或Flask框架', '2026-03-20 09:15:00'), ('产品经理', '美团', '上海', '有互联网产品经验，熟悉产品设计流程', '2026-03-19 14:45:00'), ('UI设计师', '百度', '北京', '熟练使用Figma、Sketch等设计工具', '2026-03-18 11:20:00');"
    echo [成功] 数据库和表创建完成
) else (
    echo [成功] 数据库和表已存在
)
echo.

REM 显示数据库中的数据
echo [信息] 数据库中的岗位数据:
mysql -u root -p123456 -e "USE ai_job_recommender; SELECT id, title, company, location FROM jobs;"
echo.

REM 启动后端服务
echo [信息] 正在启动后端服务...
echo 服务地址: http://localhost:8080/api
echo 按 Ctrl+C 停止服务
echo.
echo [信息] 开始执行: mvnw.cmd spring-boot:run
echo ==========================================
echo.

mvnw.cmd spring-boot:run
