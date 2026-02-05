package com.apt.membermanager.repository;

import com.apt.membermanager.entity.DaycareNotice;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DaycareNoticeRepository extends JpaRepository<DaycareNotice, Long> {
}