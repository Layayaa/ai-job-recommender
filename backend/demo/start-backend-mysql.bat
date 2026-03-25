@echo off
echo ==========================================
echo    启动后端服务（MySQL版本）
echo ==========================================
echo.

REM 检查MySQL服务是否运行
echo [信息] 检查MySQL服务状态...
sc query MySQL80 >nul 2>&1
if errorlevel 1 (
    echo [错误] MySQL服务未运行，请先启动MySQL服务
    echo 方法：Win+R → 输入 services.msc → 找到MySQL80 → 启动
    pause
    exit /b 1
) else (
    echo [成功] MySQL服务正在运行
)

echo.

REM 检查数据库是否存在
echo [信息] 检查数据库是否存在...
mysql -u root -p123456 -e "USE ai_job_recommender;" >nul 2>&1
if errorlevel 1 (
    echo [信息] 数据库不存在，正在创建...
    mysql -u root -p123456 -e "CREATE DATABASE IF NOT EXISTS ai_job_recommender CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    if errorlevel 1 (
        echo [错误] 创建数据库失败，请检查MySQL密码是否正确
        pause
        exit /b 1
    ) else (
        echo [成功] 数据库创建完成
    )
) else (
    echo [成功] 数据库已存在
)

echo.

REM 检查jobs表是否存在
echo [信息] 检查jobs表是否存在...
mysql -u root -p123456 -e "USE ai_job_recommender; SHOW TABLES LIKE 'jobs';" | findstr "jobs" >nul 2>&1
if errorlevel 1 (
    echo [信息] jobs表不存在，正在创建...
    mysql -u root -p123456 -e "USE ai_job_recommender; CREATE TABLE IF NOT EXISTS jobs (id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(255) NOT NULL, company VARCHAR(255) NOT NULL, location VARCHAR(255) NOT NULL, requirements TEXT, created_at DATETIME DEFAULT CURRENT_TIMESTAMP);"
    if errorlevel 1 (
        echo [错误] 创建表失败
        pause
        exit /b 1
    ) else (
        echo [成功] 表创建完成
        
        REM 插入模拟数据
        echo [信息] 插入模拟数据...
        mysql -u root -p123456 -e "USE ai_job_recommender; INSERT INTO jobs (title, company, location, requirements, created_at) VALUES ('Java开发工程师', '阿里巴巴', '杭州', '熟悉Java基础，熟练使用Spring Boot、MyBatis框架', '2026-03-22 10:00:00'), ('前端开发工程师', '字节跳动', '北京', '熟悉Vue.js或React，熟练掌握HTML/CSS/JavaScript', '2026-03-21 15:30:00'), ('Python开发工程师', '腾讯', '深圳', '熟练使用Python，熟悉Django或Flask框架', '2026-03-20 09:15:00'), ('产品经理', '美团', '上海', '有互联网产品经验，熟悉产品设计流程', '2026-03-19 14:45:00'), ('UI设计师', '百度', '北京', '熟练使用Figma、Sketch等设计工具', '2026-03-18 11:20:00');"
        echo [成功] 数据插入完成
    )
) else (
    echo [成功] jobs表已存在
)

echo.

REM 启动后端服务
echo [信息] 启动后端服务...
echo 服务地址: http://localhost:8080/api
echo 按 Ctrl+C 停止服务
echo.
mvnw.cmd spring-boot:run
