package com.example.microbbdd.services;

import com.example.microbbdd.entity.Api;
import com.example.microbbdd.entity.Dashboard;
import com.example.microbbdd.entity.Endpoint;
import com.example.microbbdd.entity.Parameter;
import com.example.microbbdd.repository.ApiRepository;
import com.example.microbbdd.repository.DashboardRepository;
import com.example.microbbdd.repository.EndpointRepository;
import com.example.microbbdd.repository.ParameterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class DashboardService {

    @Autowired
    private DashboardRepository dashboardRepository;

    @Autowired
    private ApiRepository apiRepository;

    @Autowired
    private EndpointRepository endpointRepository;

    @Autowired
    private ParameterRepository parameterRepository;

    @Transactional
    public Dashboard updateDashboard(Dashboard updatedDashboard) {
        // Fetch the existing dashboard from the database
        Dashboard existingDashboard = dashboardRepository.findById(updatedDashboard.getDashboardId()).orElse(null);
        if (existingDashboard == null) {
            // Handle the case where the dashboard does not exist in the database
            return null;
        }

        // Save the updated dashboard
        return dashboardRepository.save(updatedDashboard);
    }

    public List<Dashboard> getAllDashboardsByUser(String userId) {
        return dashboardRepository.getDashboardsByUserId(userId);
    }

    public Dashboard getDashboardById(Long dashboardId) {
        Optional<Dashboard> dashboard = dashboardRepository.findById(dashboardId);
        return dashboard.orElse(null);
    }

    @Transactional
    public Dashboard save(Dashboard dashboard) {
        return dashboardRepository.save(dashboard);
    }

    @Transactional
    public Dashboard deleteById(Long dashboardId) {
        Optional<Dashboard> dashboard = dashboardRepository.findById(dashboardId);
        if (dashboard.isPresent()) {
            dashboardRepository.deleteById(dashboardId);
            return dashboard.get();
        }
        return null;
    }
}
