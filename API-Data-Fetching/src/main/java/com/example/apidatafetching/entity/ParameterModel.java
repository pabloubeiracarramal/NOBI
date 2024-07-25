package com.example.apidatafetching.entity;

import java.util.Objects;

public class ParameterModel {

    private Long parameterId;

    private String parameter;

    private String value;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ParameterModel that = (ParameterModel) o;
        return Objects.equals(getParameterId(), that.getParameterId()) && Objects.equals(getParameter(), that.getParameter()) && Objects.equals(getValue(), that.getValue());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getParameterId(), getParameter(), getValue());
    }


    public Long getParameterId() {
        return parameterId;
    }

    public void setParameterId(Long parameterId) {
        this.parameterId = parameterId;
    }

    public String getParameter() {
        return parameter;
    }

    public void setParameter(String parameter) {
        this.parameter = parameter;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
