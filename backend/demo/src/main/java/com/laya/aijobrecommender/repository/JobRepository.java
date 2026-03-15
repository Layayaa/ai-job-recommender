package com.laya.aijobrecommender.repository;

import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.laya.aijobrecommender.entity.Job; // 👈 加上这一行！

@Repository
public interface JobRepository extends JpaRepository<Job, Long> {
    // 无需写方法，JPA 自动提供 save, findAll, findById, deleteById 等
}