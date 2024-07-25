package com.example.microbbdd.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "apis")
public class Api {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "api_id")
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "base_url")
    private String baseUrl;

    @Column(name = "token")
    private String token;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "dashboard_id", nullable = false) // This should match the column name in 'apis' table.
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JsonBackReference("dashboard-api")
    private Dashboard dashboard;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "api", cascade = CascadeType.ALL, orphanRemoval = true)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JsonManagedReference("api-endpoint")
    private List<Endpoint> endpoints = new ArrayList<>();

    @Override
    public String toString() {
        return "Api{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", url='" + baseUrl + '\'' +
                ", dashboard=" + dashboard +
                '}';
    }

    public Api removeEndpoint(Endpoint endpoint){

        if (endpoint == null){
            return this;
        }

        endpoints.remove(endpoint);

        return this;

    }

    public Long getId() { return id; }

    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }

    public void setName(String name) { this.name = name; }

    public String getBaseUrl() { return baseUrl; }

    public void setBaseUrl(String baseUrl) { this.baseUrl = baseUrl; }

    public Dashboard getDashboard() { return dashboard; }

    public void setDashboard(Dashboard dashboard) { this.dashboard = dashboard; }

    public List<Endpoint> getEndpoints() {
        return endpoints;
    }

    public void setEndpoints(List<Endpoint> endpoints) {
        this.endpoints = endpoints;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}
