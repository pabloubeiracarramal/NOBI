package com.example.microbbdd.utilities;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.Serializable;
import java.util.Map;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class JsonData implements Serializable {

    private Map<String, Object> data;

    public JsonData() {
        // Initialize the map or leave it for lazy initialization
    }

    public JsonData(Map<String, Object> data) {
        this.data = data;
    }

    // Method to serialize your object to JSON string
    public String toJson() {
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.writeValueAsString(this);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // Method to deserialize JSON string to your object
    public static JsonData fromJson(String json) {
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.readValue(json, JsonData.class);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public Map<String, Object> getData() {
        return data;
    }

    public void setData(Map<String, Object> data) {
        this.data = data;
    }

    public void addData(String key, Object value) {
        this.data.put(key, value);
    }

    public Object getData(String key) {
        return this.data.get(key);
    }

    @Override
    public String toString() {
        return "JsonData{" +
                "data=" + data +
                '}';
    }
}
