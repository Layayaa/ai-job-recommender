package com.laya.aijobrecommender.controller;

import com.laya.aijobrecommender.service.AIService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@RestController
@RequestMapping("/api/ai")
@CrossOrigin(origins = "*")
public class AIController {

    @Autowired
    private AIService aiService;

    /**
     * 上传简历文件，获取 AI 推荐
     */
    @PostMapping("/upload-resume")
    public ResponseEntity<?> uploadResume(@RequestParam("resume") MultipartFile file) {
        try {
            // 1. 读取简历文本（简单版：只处理文本文件）
            String resumeText = new String(file.getBytes());

            // 2. 调用 Dify 工作流
            String aiResponse = aiService.analyzeResume(resumeText);

            // 3. 返回推荐结果
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "简历分析成功",
                    "aiResponse", aiResponse
            ));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "简历解析失败: " + e.getMessage()
            ));
        }
    }

    /**
     * 文本简历分析（备用接口）
     */
    @PostMapping("/analyze-text")
    public ResponseEntity<?> analyzeTextResume(@RequestBody Map<String, String> request) {
        String resumeText = request.get("text");
        if (resumeText == null || resumeText.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("简历文本不能为空");
        }

        try {
            String aiResponse = aiService.analyzeResume(resumeText);
            return ResponseEntity.ok(aiResponse);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body("AI 分析失败: " + e.getMessage());
        }
    }
}