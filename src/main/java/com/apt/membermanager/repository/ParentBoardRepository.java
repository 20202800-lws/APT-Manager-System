package com.apt.membermanager.repository;

import com.apt.membermanager.entity.ParentBoard;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ParentBoardRepository extends JpaRepository<ParentBoard, Long> {
	
}