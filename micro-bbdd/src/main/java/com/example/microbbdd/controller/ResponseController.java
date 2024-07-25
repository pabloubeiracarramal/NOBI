package com.example.microbbdd.controller;

import com.example.microbbdd.entity.Api;
import com.example.microbbdd.entity.Dashboard;
import com.example.microbbdd.services.DashboardService;
import com.example.microbbdd.services.ResponseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/microddbb/response")
public class ResponseController {

    @Autowired
    private ResponseService responseService;

    // RESPONSE CRUD
    // =============

    @GetMapping("/{endpointId}")
    public ResponseEntity<?> retrieveResponse(@PathVariable Long endpointId) {

        ResponseEntity<?> response = responseService.retrieveResponse(endpointId);

        return response;

    }

    @PostMapping("/{endpointId}")
    public ResponseEntity<?> storeResponse(@PathVariable Long endpointId, @RequestBody Map<String, Object> responseBody) {

        System.out.println(responseBody);

        ResponseEntity<?> response = responseService.save(endpointId, responseBody);

        return new ResponseEntity<>(response.getBody(), HttpStatus.OK);
    }

    @PostMapping("/historic/{endpointId}")
    public ResponseEntity<?> storeHistoricResponse(@PathVariable Long endpointId, @RequestBody Map<String, Object> responseBody) {

        System.out.println(responseBody);

        ResponseEntity<?> response = responseService.saveHistoric(endpointId, responseBody);

        return new ResponseEntity<>(response.getBody(), HttpStatus.OK);

    }

}
