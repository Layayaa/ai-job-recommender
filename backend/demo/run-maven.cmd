@echo off

REM 设置Maven路径
set MAVEN_HOME=D:\ai-job-recommender\maven\apache-maven-3.9.14
set PATH=%MAVEN_HOME%\bin;%PATH%

echo 正在编译项目...
mvn clean compile

if %ERRORLEVEL% equ 0 (
    echo 编译成功！
    echo 正在启动Spring Boot应用...
    mvn spring-boot:run
) else (
    echo 编译失败，请检查错误信息。
    pause
)
