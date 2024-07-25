package com.example.microbbdd.entity;

import com.example.microbbdd.utilities.JsonData;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import com.vladmihalcea.hibernate.type.json.JsonBinaryType;
import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.hibernate.type.SqlTypes;
import com.fasterxml.jackson.annotation.JsonIdentityInfo;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "responses")
//@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "responseId")
public class Response {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "responseId")
    private Long responseId;

    @Column(name = "data")
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonData data;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "endpoint_id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JsonIgnore
    private Endpoint endpoint;

    @ManyToMany(mappedBy = "responses", fetch = FetchType.LAZY)
    @JsonIgnore
    private List<Kpi> kpis = new ArrayList<>();

    @Override
    public String toString() {
        return "Response{" +
                "responseId=" + responseId +
                ", data=" + data +
                ", endpoint=" + endpoint +
                '}';
    }

    public Long getResponseId() {
        return responseId;
    }

    public void setResponseId(Long responseId) {
        this.responseId = responseId;
    }

    public JsonData getData() {
        return data;
    }

    public void setData(JsonData data) {
        this.data = data;
    }

    public Endpoint getEndpoint() {
        return endpoint;
    }

    public void setEndpoint(Endpoint endpoint) {
        this.endpoint = endpoint;
    }

    public List<Kpi> getKpis() {
        return kpis;
    }

    public void setKpis(List<Kpi> kpis) {
        this.kpis = kpis;
    }
}
