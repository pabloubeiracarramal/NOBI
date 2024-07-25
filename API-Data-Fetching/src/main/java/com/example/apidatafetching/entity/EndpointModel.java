package com.example.apidatafetching.entity;

import java.util.List;
import java.util.Objects;

public class EndpointModel {

    private Long endpointId;
    private String url;
    private String method;

    private String mode;

    private List<ParameterModel> parameters;

    private int waitTime;

    public EndpointModel() {
        // Default constructor
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        EndpointModel that = (EndpointModel) o;
        return waitTime == that.waitTime && Objects.equals(endpointId, that.endpointId) && Objects.equals(url, that.url) && Objects.equals(method, that.method) && Objects.equals(mode, that.mode) && Objects.equals(parameters, that.parameters);
    }

    @Override
    public int hashCode() {
        return Objects.hash(endpointId, url, method, mode, parameters, waitTime);
    }

    @Override
    public String toString() {
        return "EndpointModel{" +
                "endpointId=" + endpointId +
                ", url='" + url + '\'' +
                ", method='" + method + '\'' +
                ", mode='" + mode + '\'' +
                ", parameters=" + parameters +
                ", waitTime=" + waitTime +
                '}';
    }

    public Long getEndpointId() {
        return endpointId;
    }

    public void setEndpointId(Long endpointId) {
        this.endpointId = endpointId;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public int getWaitTime() {
        return waitTime;
    }

    public void setWaitTime(int waitTime) {
        this.waitTime = waitTime;
    }


    public List<ParameterModel> getParameters() {
        return parameters;
    }

    public void setParameters(List<ParameterModel> parameters) {
        this.parameters = parameters;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }
}
