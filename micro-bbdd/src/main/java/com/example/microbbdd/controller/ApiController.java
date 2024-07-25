package com.example.microbbdd.controller;

import com.example.microbbdd.entity.Api;
import com.example.microbbdd.services.ApiService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/microddbb/api")
public class ApiController {

    @Autowired
    private ApiService apiService;

    @GetMapping("/{apiId}")
    public ResponseEntity<Api> retrieveApi(@PathVariable Long apiId){

        if (apiId == null){
            return ResponseEntity.badRequest().build();
        }

        Api api = apiService.getApi(apiId);

        if (api == null){
            return ResponseEntity.notFound().build();
        }

        return new ResponseEntity<>(api, HttpStatus.OK);

    }

}
