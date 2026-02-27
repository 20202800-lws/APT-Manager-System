package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Program;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProgramRepository extends JpaRepository<Program, Long> {
    // 기본 CRUD (findAll 등을 사용하여 강습 목록을 불러옵니다)
}