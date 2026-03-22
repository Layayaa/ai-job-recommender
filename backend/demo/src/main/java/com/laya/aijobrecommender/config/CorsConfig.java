package com.laya.aijobrecommender.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins(
                        "http://localhost:63342",  // WebStorm 开发服务器
                        "http://localhost:5173",   // Vite 开发服务器
                        "http://localhost:3000",   // React 开发服务器
                        "http://localhost:8080"    // Spring Boot 后端
                )
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)  // ✅ 允许携带凭证（Cookie、Authorization等）
                .maxAge(3600);  // 预检请求缓存1小时
    }
}