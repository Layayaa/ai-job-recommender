@echo off
echo ==========================================
echo    启动后端服务
echo ==========================================
echo.

REM 直接启动后端服务
echo [信息] 正在启动后端服务...
echo 服务地址: http://localhost:8080/api
echo 按 Ctrl+C 停止服务
echo.

REM 使用Maven包装器启动服务
mvnw.cmd spring-boot:run
