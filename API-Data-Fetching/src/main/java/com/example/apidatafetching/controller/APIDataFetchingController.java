package com.example.apidatafetching.controller;

import com.example.apidatafetching.entity.DashboardModel;
import com.example.apidatafetching.entity.ResponseModel;
import com.example.apidatafetching.service.DataFetchingService;
import com.example.apidatafetching.service.DynamicTaskSchedulingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/apidatafetching")
public class APIDataFetchingController {

    @Autowired
    private DynamicTaskSchedulingService dynamicTaskSchedulingService;

    @Autowired
    private DataFetchingService dataFetchingService;

    @Autowired
    private DataController dataController;

    @GetMapping("/ok")
    public ResponseEntity<String> isOk() throws Exception {
        return new ResponseEntity<>("Everything is allright.", HttpStatus.OK);
    }

    @GetMapping("/sample/{apiId}/{endpointId}")
    public ResponseEntity<ResponseModel> getSampleResponse(@PathVariable String apiId, @PathVariable String endpointId) {

        // Check for missing parameters
        if (apiId == null || endpointId == null) {
            return ResponseEntity.badRequest().build();
        }

        ResponseEntity<ResponseModel> response = dataFetchingService.fetchSampleData(apiId, endpointId);

        return response;

    }

    @GetMapping("/dashboard/{dashboardId}")
    public ResponseEntity<String> statusDashboard(@PathVariable String dashboardId) {

        // Check for missing parameters
        if (dashboardId == null) {
            return ResponseEntity.badRequest().build();
        }

        String status = dynamicTaskSchedulingService.statusDashboardTask(dashboardId);

        // Return if error
        if (status == null){
            return ResponseEntity.notFound().build();
        }

        return new ResponseEntity<>(status, HttpStatus.OK);
    }

    @PostMapping("/dashboard/start/{dashboardId}")
    public ResponseEntity<DashboardModel> startDashboard(@PathVariable String dashboardId) {

        // Check for missing parameters
        if (dashboardId == null) {
            return ResponseEntity.badRequest().build();
        }

        // Call DataFetchingService to start process
        DashboardModel startedDashboard = dynamicTaskSchedulingService.scheduleDashboardTask(dashboardId);

        // Return if dashboard is not found
        if (startedDashboard == null){
            return ResponseEntity.notFound().build();
        }

        // Update status
        String status = dynamicTaskSchedulingService.statusDashboardTask(dashboardId);
        dataController.sendStatus(status);
        System.out.println("STATUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUS");

        // Return started dashboard
        return new ResponseEntity<DashboardModel>(startedDashboard, HttpStatus.OK);


    }

    @PostMapping("/dashboard/stop/{dashboardId}")
    public ResponseEntity<DashboardModel> stopDashboard(@PathVariable String dashboardId) {

        // Check for missing parameters
        if (dashboardId == null) {
            return ResponseEntity.badRequest().build();
        }

        // Call DataFetchingService to start process
        DashboardModel startedDashboard = dynamicTaskSchedulingService.stopDashboardTask(dashboardId);

        // Return if dashboard is not found
        if (startedDashboard == null){
            return ResponseEntity.notFound().build();
        }

        // Update status
        String status = dynamicTaskSchedulingService.statusDashboardTask(dashboardId);
        dataController.sendStatus(status);

        // Return started dashboard
        return new ResponseEntity<DashboardModel>(startedDashboard, HttpStatus.OK);
    }

}
