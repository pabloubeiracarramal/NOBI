package com.example.apidatafetching.entity;

import java.util.List;
import java.util.Objects;


public class ApiModel {

    private Long id;

    private String name; // A friendly name for the API

    private String baseUrl; // The base URL for the API

    private String token;

    private List<EndpointModel> endpoints;



    // Constructors, getters, setters, equals, and hashCode methods

    public ApiModel() {
        // Default constructor
    }

    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ApiModel)) return false;
        ApiModel apiModel = (ApiModel) o;
        return Objects.equals(id, apiModel.id) &&
                Objects.equals(name, apiModel.name) &&
                Objects.equals(baseUrl, apiModel.baseUrl);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, name, baseUrl);
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public List<EndpointModel> getEndpoints() {
        return endpoints;
    }

    public void setEndpoints(List<EndpointModel> endpoints) {
        this.endpoints = endpoints;
    }

    // Additional methods such as toString(), if needed
}
