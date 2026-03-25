@echo off
echo ==========================================
echo    MySQL数据库初始化脚本
echo ==========================================
echo.

REM 检查MySQL是否安装
mysql --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到MySQL命令，请确保MySQL已安装并添加到PATH环境变量
    pause
    exit /b 1
)

echo [信息] 正在初始化数据库...
mysql -u root -p < init-mysql.sql

if errorlevel 1 (
    echo [错误] 数据库初始化失败，请检查：
    echo   1. MySQL服务是否已启动
    echo   2. root密码是否正确
    echo   3. MySQL是否允许root远程登录
    pause
    exit /b 1
) else (
    echo [成功] 数据库初始化完成！
    echo.
    echo 数据库名称: ai_job_recommender
    echo 表名: jobs
    echo 数据条数: 5条模拟数据
    pause
)
