package com.example.microbbdd.controller;

import com.example.microbbdd.entity.Endpoint;
import com.example.microbbdd.services.EndpointService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/microddbb/endpoint")
public class EndpointController {

    @Autowired
    private EndpointService endpointService;

    @GetMapping("/{endpointId}")
    public ResponseEntity<Endpoint> retrieveEndpoint(@PathVariable Long endpointId) {

        if (endpointId == null) {
            return ResponseEntity.badRequest().build();
        }

        Endpoint endpoint = endpointService.getEndpoint(endpointId);

        if (endpoint == null){
            return ResponseEntity.notFound().build();
        }

        return new ResponseEntity<>(endpoint, HttpStatus.OK);

    }

}
