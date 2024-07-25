package com.example.microbbdd.controller;

import com.example.microbbdd.entity.Api;
import com.example.microbbdd.entity.Dashboard;
import com.example.microbbdd.entity.Endpoint;
import com.example.microbbdd.repository.ResponseRepository;
import com.example.microbbdd.services.ApiService;
import com.example.microbbdd.services.DashboardService;
import com.example.microbbdd.services.EndpointService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Objects;

@RestController
@RequestMapping("/microddbb/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private ApiService apiService;

    @Autowired
    private EndpointService endpointService;

    @GetMapping("/ok")
    public ResponseEntity<String> isOk() throws Exception {
        return new ResponseEntity<>("Everything is allright.", HttpStatus.OK);
    }

    @GetMapping("/user")
    public ResponseEntity<List<Dashboard>> getDashboardsByUser(@RequestHeader Map<String, String> headers) {

        String uid = headers.get("uid");

        List<Dashboard> dashboards = dashboardService.getAllDashboardsByUser(uid);
        return new ResponseEntity<>(dashboards, HttpStatus.OK);
    }


    // DASHBOARD CRUD
    // ==============

    @GetMapping("/{dashboardId}")
    public ResponseEntity<Dashboard> getDashboardById(@PathVariable Long dashboardId) {

        // Check for missing parameters
        if (dashboardId == null) {
            return ResponseEntity.badRequest().build();
        }

        // Business logic for retrieving the dashboard from bd
        Dashboard dashboard = dashboardService.getDashboardById(dashboardId);

        // Return if dashboard doesn't exist
        if (dashboard == null){
            return ResponseEntity.notFound().build();
        }

        // Return dashboard
        return new ResponseEntity<>(dashboard, HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<Dashboard> addDashboard(@RequestBody Dashboard dashboard) {

        // Check for missing parameters
        if (dashboard == null) {
            return ResponseEntity.badRequest().build();
        }

        // Business logic for storing the dashboard in db
        Dashboard savedDashboard = dashboardService.save(dashboard);

        // Return dashboard
        return new ResponseEntity<>(savedDashboard, HttpStatus.OK);
    }

    @PutMapping
    public ResponseEntity<Dashboard> updateDashboard(@RequestBody Dashboard dashboard) {

        // Check for missing parameters
        if (dashboard == null) {
            return ResponseEntity.badRequest().build();
        }

        System.out.println(dashboard);

        // Business logic for storing the dashboard in db
        Dashboard savedDashboard = dashboardService.updateDashboard(dashboard);

        // Return dashboard
        return new ResponseEntity<>(savedDashboard, HttpStatus.CREATED);
    }

    @DeleteMapping("/{dashboardId}")
    public ResponseEntity<Dashboard> deleteDashboard (@PathVariable Long dashboardId) {

        // Check for missing parameters
        if (dashboardId == null)
            return ResponseEntity.badRequest().build();

        // Business logic for deleting the dashboard from the db
        Dashboard updatedDashboard = dashboardService.deleteById(dashboardId);

        // Return if dashboard doesn't exist
        if ( updatedDashboard == null ) {
            return ResponseEntity.notFound().build();
        }

        // Return deleted dashboard
        return new ResponseEntity<>(updatedDashboard, HttpStatus.OK);
    }

}
