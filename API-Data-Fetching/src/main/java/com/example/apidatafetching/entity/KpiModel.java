package com.example.apidatafetching.entity;

public class KpiModel {

    private Long kpiId;

    private String title;

    private String position;

    private String entry;

    private Long endpointId;

    private Long dashboardId;

    private String type;

    @Override
    public String toString() {
        return "KpiModel{" +
                "kpiId=" + kpiId +
                ", title='" + title + '\'' +
                ", position='" + position + '\'' +
                ", entry='" + entry + '\'' +
                ", endpointId=" + endpointId +
                ", dashboardId=" + dashboardId +
                ", type=" + getType() +
                '}';
    }

    public Long getKpiId() {
        return kpiId;
    }

    public void setKpiId(Long kpiId) {
        this.kpiId = kpiId;
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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
