package com.example.microbbdd.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "dashboards")
public class Dashboard {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "dashboardId")
    private Long dashboardId;

    @Column(name = "userId")
    private String userId;

    @Column(name = "title")
    private String title;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "dashboard", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference("dashboard-api")
    private List<Api> apis = new ArrayList<>();

    @Override
    public String toString() {
        return "Dashboard{" +
                "dashboardId=" + dashboardId +
                ", userId='" + userId + '\'' +
                ", title='" + title + '\'' +
                '}';
    }

    public Dashboard removeApi(Api api){

        if (api == null){
            return this;
        }

        apis.remove(api);

        return this;

    }

    public Long getDashboardId() {
        return dashboardId;
    }

    public void setDashboardId(Long dashboardId) {
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

    public List<Api> getApis() {
        return apis;
    }

    public void setApis(List<Api> apis) {
        this.apis = apis;
    }
}
