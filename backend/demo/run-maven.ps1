# 设置Maven路径
$MAVEN_HOME = "D:\ai-job-recommender\maven\apache-maven-3.9.14"
$env:PATH = "$MAVEN_HOME\bin;$env:PATH"

Write-Host "正在编译项目..."
& "$MAVEN_HOME\bin\mvn" clean compile

if ($LASTEXITCODE -eq 0) {
    Write-Host "编译成功！"
    Write-Host "正在启动Spring Boot应用..."
    & "$MAVEN_HOME\bin\mvn" spring-boot:run
} else {
    Write-Host "编译失败，请检查错误信息。"
    Read-Host "按Enter键退出..."
}
