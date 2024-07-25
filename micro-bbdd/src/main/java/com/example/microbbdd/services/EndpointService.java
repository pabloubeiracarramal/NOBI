package com.example.microbbdd.services;

import com.example.microbbdd.entity.Endpoint;
import com.example.microbbdd.repository.EndpointRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class EndpointService {

    @Autowired
    private EndpointRepository endpointRepository;

    public Endpoint addEndpoint(Endpoint endpoint) {
        return endpointRepository.save(endpoint);
    }

    public Endpoint removeEndpoint(Long endpointId) {
        Optional<Endpoint> endpoint = endpointRepository.findById(endpointId);

        if (endpoint.isEmpty()) {
            return null;
        }

        endpointRepository.delete(endpoint.get());

        return endpoint.get();
    }

    public Endpoint getEndpoint(Long endpointId) {

        Optional<Endpoint> endpoint = endpointRepository.findById(endpointId);

        if (endpoint.isEmpty()) {
            return null;
        }

        return endpoint.get();

    }

}
