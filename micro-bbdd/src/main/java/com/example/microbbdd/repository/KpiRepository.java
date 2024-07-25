package com.example.microbbdd.repository;

import com.example.microbbdd.entity.Kpi;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface KpiRepository extends JpaRepository<Kpi, Long> {


    List<Kpi> findKpisByEndpointId(Long endpointId);

    List<Kpi> findKpisByDashboardId(Long dashboardId);

    Kpi findKpiByKpiId(Long kpiId);

}
