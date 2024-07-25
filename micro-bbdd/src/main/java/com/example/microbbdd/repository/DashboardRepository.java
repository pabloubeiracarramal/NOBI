package com.example.microbbdd.repository;

import com.example.microbbdd.entity.Dashboard;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DashboardRepository extends JpaRepository<Dashboard, Long> {

    @Query("SELECT d FROM Dashboard d WHERE d.userId = ?1")
    List<Dashboard> getDashboardsByUserId(String userId);


    @Query("SELECT d FROM Dashboard d WHERE d.dashboardId = ?1")
    Dashboard getDashboardByDashboardId(Long dashboardId);

}
