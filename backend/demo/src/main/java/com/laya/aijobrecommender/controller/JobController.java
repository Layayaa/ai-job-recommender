package com.laya.aijobrecommender.controller;

import com.laya.aijobrecommender.entity.Job;
import com.laya.aijobrecommender.repository.JobRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/jobs")
public class JobController {

    @Autowired
    private JobRepository jobRepository;

    // 获取所有岗位
    @GetMapping
    public List<Job> getAllJobs() {
        return jobRepository.findAll();
    }
}