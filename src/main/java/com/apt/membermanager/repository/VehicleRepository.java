package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Vehicle;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface VehicleRepository extends JpaRepository<Vehicle, String> {
    List<Vehicle> findByUser_UserId(String userId);
}