package com.example.microbbdd.services;

import com.example.microbbdd.entity.Endpoint;
import com.example.microbbdd.entity.Response;
import com.example.microbbdd.repository.EndpointRepository;
import com.example.microbbdd.repository.ResponseRepository;
import com.example.microbbdd.utilities.JsonData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ResponseService {

    @Autowired
    private ResponseRepository responseRepository;

    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private EndpointRepository endpointRepository;

    public ResponseEntity<Response> retrieveResponse(Long endpointId) {

        // Retrieve the Endpoint entity
        Optional<Endpoint> endpointOptional = endpointRepository.findById(endpointId);
        if (endpointOptional.isEmpty()) {
            return ResponseEntity.badRequest().body(null);
        }

        Optional<Response> existingResponse = responseRepository.findByEndpointId(endpointId);

        if (existingResponse.isEmpty()) {
            return ResponseEntity.badRequest().body(null);
        }

        return new ResponseEntity<>(existingResponse.get(), HttpStatus.OK);

    }

    public ResponseEntity<Response> save(Long endpointId, Map<String, Object> responseBody) {
        JsonData jsonData = new JsonData(responseBody);

        // Retrieve the Endpoint entity
        Optional<Endpoint> endpointOptional = endpointRepository.findById(endpointId);
        if (endpointOptional.isEmpty()) {
            return ResponseEntity.badRequest().body(null);
        }

        Endpoint endpoint = endpointOptional.get();

        // Create response
        Response response = null;

        // Check if response already exists
        Optional<Response> existingResponse = responseRepository.findByEndpointId(endpointId);
        response = existingResponse.orElseGet(Response::new);

        // Set new values to response
        response.setData(jsonData);
        response.setEndpoint(endpoint);

        // Save the response
        Response savedResponse = responseRepository.save(response);

        // Return a successful response entity
        return ResponseEntity.ok(savedResponse);
    }

    public ResponseEntity<Response> saveHistoric(Long endpointId, Map<String, Object> responseBody) {

        JsonData jsonData = new JsonData(responseBody);

        // Retrieve the Endpoint entity
        Optional<Endpoint> endpointOptional = endpointRepository.findById(endpointId);
        if (endpointOptional.isEmpty()) {
            return ResponseEntity.badRequest().body(null);
        }

        Endpoint endpoint = endpointOptional.get();

        Response response = new Response();
        response.setData(jsonData);
        response.setEndpoint(endpoint);

        Response savedResponse = responseRepository.save(response);

        return ResponseEntity.ok(savedResponse);

    }

}
