package com.example.apidatafetching.entity;

import java.util.List;

public class DashboardModel {

    private String dashboardId;
    private String userId;
    private String title;
    private List<ApiModel> apiModels;

    @Override
    public String toString() {
        return "DashboardModel{" +
                "dashboardId='" + dashboardId + '\'' +
                ", userId='" + userId + '\'' +
                ", title='" + title + '\'' +
                '}';
    }

    public String getDashboardId() {
        return dashboardId;
    }

    public void setDashboardId(String dashboardId) {
        this.dashboardId = dashboardId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public List<ApiModel> getApis() {
        return apiModels;
    }

    public void setApis(List<ApiModel> apiModels) {
        this.apiModels = apiModels;
    }
}
