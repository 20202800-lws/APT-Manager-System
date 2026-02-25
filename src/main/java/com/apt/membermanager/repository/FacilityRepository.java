package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Facility;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FacilityRepository extends JpaRepository<Facility, String> {
    // 기본 CRUD만으로도 충분합니다!
}