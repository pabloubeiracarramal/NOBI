package com.example.microbbdd.repository;

import com.example.microbbdd.entity.Response;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ResponseRepository extends JpaRepository<Response, Long> {

    @Query("SELECT response FROM Response response WHERE response.endpoint.endpointId = ?1")
    Optional<Response> findByEndpointId(Long endpointId);

}
