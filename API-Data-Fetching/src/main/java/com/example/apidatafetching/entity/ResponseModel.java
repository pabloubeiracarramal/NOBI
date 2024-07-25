package com.example.apidatafetching.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.JsonNode;

import java.util.ArrayList;
import java.util.List;

public class ResponseModel {

    private Long responseId;

    private JsonNode data;

    private EndpointModel endpoint;

    private List<KpiModel> kpis = new ArrayList<>();

    @Override
    public String toString() {
        return "ResponseModel{" +
                "responseId=" + responseId +
                ", data='" + data + '\'' +
                ", endpoint=" + endpoint +
                ", kpis=" + kpis +
                '}';
    }

    public Long getResponseId() {
        return responseId;
    }

    public void setResponseId(Long responseId) {
        this.responseId = responseId;
    }

    public JsonNode getData() {
        return data;
    }

    public void setData(JsonNode data) {
        this.data = data;
    }

    public EndpointModel getEndpoint() {
        return endpoint;
    }

    public void setEndpoint(EndpointModel endpoint) {
        this.endpoint = endpoint;
    }

    public List<KpiModel> getKpis() {
        return kpis;
    }

    public void setKpis(List<KpiModel> kpis) {
        this.kpis = kpis;
    }
}
