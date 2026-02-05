package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Program;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProgramRepository extends JpaRepository<Program, Long> {
	
}