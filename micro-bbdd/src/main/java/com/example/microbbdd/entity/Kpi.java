package com.example.microbbdd.entity;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "kpis")
@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "kpiId")
public class Kpi {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "kpi_id")
    private Long kpiId;

    @Column(name = "title")
    private String title;

    @Column(name = "position")
    private String position;

    @Column(name = "entry")
    private String entry;

    @JoinColumn(name = "endpoint_id", nullable = false)
    @Column(name = "endpoint_id")
    private Long endpointId;

    @JoinColumn(name = "dashboard_id", nullable = false)
    @Column(name = "dashboard_id")
    private Long dashboardId;

    @ManyToMany(fetch = FetchType.EAGER, cascade = { CascadeType.PERSIST, CascadeType.MERGE, CascadeType.DETACH, CascadeType.REFRESH })
    @JoinTable(name = "kpi_response",
            joinColumns = @JoinColumn(name = "kpi_id"),
            inverseJoinColumns = @JoinColumn(name = "response_id"))

    private List<Response> responses = new ArrayList<>();

    @Column(name = "type")
    private String type;

    @Override
    public String toString() {
        return "Kpi{" +
                "id=" + kpiId +
                ", title='" + title + '\'' +
                ", position='" + position + '\'' +
                ", entry='" + entry + '\'' +
                ", endpoint=" + endpointId +
                ", responses=" + getResponses() +
                ", type=" + getType() +
                '}';
    }

    public Long getKpiId() {
        return kpiId;
    }

    public void setKpiId(Long id) {
        this.kpiId = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getEntry() {
        return entry;
    }

    public void setEntry(String entry) {
        this.entry = entry;
    }

    public Long getEndpointId() {
        return endpointId;
    }

    public void setEndpointId(Long endpointId) {
        this.endpointId = endpointId;
    }

    public Long getDashboardId() {
        return dashboardId;
    }

    public void setDashboardId(Long dashboardId) {
        this.dashboardId = dashboardId;
    }

    public List<Response> getResponses() {
        return responses;
    }

    public void setResponses(List<Response> responses) {
        this.responses = responses;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
