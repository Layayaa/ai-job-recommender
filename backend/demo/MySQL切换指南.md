# MySQL数据库切换指南

## 已完成的工作

### 1. 配置文件修改 ✅
- 修改了 `application.properties`，将H2配置改为MySQL配置
- 数据库连接URL：`jdbc:mysql://localhost:3306/ai_job_recommender`
- 用户名：`root`
- 密码：`123456`（请根据你的实际密码修改）
- 驱动类：`com.mysql.cj.jdbc.Driver`

### 2. 依赖检查 ✅
- `pom.xml` 中已经包含MySQL驱动依赖：`mysql-connector-j`
- 无需额外添加依赖

### 3. 数据库初始化脚本 ✅
- 创建了 `init-mysql.sql` - 数据库初始化SQL脚本
- 创建了 `init-mysql.bat` - Windows批处理脚本，一键初始化数据库

## 切换步骤

### 步骤1：修改数据库密码
打开 `application.properties` 文件，修改密码：
```properties
spring.datasource.password=你的MySQL密码
```

### 步骤2：初始化MySQL数据库
**方法一：使用批处理脚本（推荐）**
1. 双击运行 `init-mysql.bat`
2. 输入MySQL root密码
3. 等待初始化完成

**方法二：手动执行SQL**
1. 打开MySQL命令行或MySQL Workbench
2. 执行 `init-mysql.sql` 中的SQL语句

### 步骤3：启动后端服务
```bash
# 使用Maven包装器
mvnw.cmd spring-boot:run

# 或者使用系统Maven（如果已配置环境变量）
mvn spring-boot:run
```

### 步骤4：验证连接
1. 打开浏览器访问：`http://localhost:8080/api/jobs`
2. 如果看到JSON格式的岗位列表，说明MySQL连接成功

## 常见问题

### 1. 连接失败：Access denied for user 'root'@'localhost'
**解决方案：**
- 检查密码是否正确
- 确保MySQL服务已启动
- 尝试在MySQL中执行：
```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '你的密码';
FLUSH PRIVILEGES;
```

### 2. 连接失败：Unknown database 'ai_job_recommender'
**解决方案：**
- 运行 `init-mysql.bat` 创建数据库
- 或手动执行：
```sql
CREATE DATABASE ai_job_recommender CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 3. 连接失败：Communications link failure
**解决方案：**
- 确保MySQL服务已启动
- 检查MySQL端口是否为3306
- 检查防火墙设置

### 4. 时区警告
已在URL中添加 `serverTimezone=UTC` 参数，如需修改时区：
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/ai_job_recommender?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
```

## 配置文件对比

### H2配置（旧）
```properties
spring.datasource.url=jdbc:h2:mem:ai_job_recommender;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE
spring.datasource.username=sa
spring.datasource.password=
spring.datasource.driver-class-name=org.h2.Driver
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
```

### MySQL配置（新）
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/ai_job_recommender?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=123456
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

## 注意事项

1. **密码安全**：生产环境请使用更复杂的密码，并考虑使用环境变量或配置文件加密
2. **数据库权限**：建议创建专用用户，而非使用root用户
3. **字符集**：数据库使用utf8mb4字符集，支持完整的Unicode字符（包括emoji）
4. **连接池**：Spring Boot自动配置HikariCP连接池，无需额外配置

## 回滚到H2

如需回滚到H2内存数据库，只需恢复 `application.properties` 中的H2配置即可。
