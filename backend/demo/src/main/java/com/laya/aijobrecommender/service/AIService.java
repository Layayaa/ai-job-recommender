package com.laya.aijobrecommender.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Map;
import java.util.HashMap;

@Service
public class AIService {

    @Value("${dify.api.key}")  // 从 application.properties 读取
    private String difyApiKey;

    @Value("${dify.workflow.url}")  // Dify 工作流调用地址
    private String workflowUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    /**
     * 调用 Dify 工作流分析简历
     */
    public String analyzeResume(String resumeText) {
        // 1. 构建请求头
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Bearer " + difyApiKey);

        // 2. 构建请求体（根据你的 Dify 工作流输入参数调整）
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("inputs", Map.of(
                "resume_text", resumeText,  // 输入变量名，需与 Dify 工作流一致
                "user_query", "请分析这份简历，推荐匹配的实习岗位"
        ));

        // 3. 发送请求到 Dify
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
        ResponseEntity<Map> response = restTemplate.exchange(
                workflowUrl,
                HttpMethod.POST,
                entity,
                Map.class
        );

        // 4. 解析响应（根据 Dify 返回格式调整）
        Map<String, Object> responseBody = response.getBody();
        if (responseBody != null && responseBody.containsKey("data")) {
            return responseBody.get("data").toString();
        } else {
            throw new RuntimeException("Dify 返回格式异常: " + responseBody);
        }
    }
}