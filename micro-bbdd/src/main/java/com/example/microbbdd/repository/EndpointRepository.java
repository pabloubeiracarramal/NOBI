package com.example.microbbdd.repository;

import com.example.microbbdd.entity.Endpoint;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EndpointRepository extends JpaRepository<Endpoint, Long> {
    // You can add custom methods if needed
}
