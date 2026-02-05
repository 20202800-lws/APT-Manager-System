package com.apt.membermanager.repository;

import com.apt.membermanager.entity.VisitVehicle;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface VisitVehicleRepository extends JpaRepository<VisitVehicle, Long> {
    List<VisitVehicle> findByUser_UserIdOrderByVisitDateDesc(String userId);
}