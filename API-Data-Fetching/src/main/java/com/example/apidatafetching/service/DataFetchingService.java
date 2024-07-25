package com.example.apidatafetching.service;

import com.example.apidatafetching.entity.*;
import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import javax.xml.crypto.dsig.XMLObject;
import java.net.URI;
import java.util.List;
import java.util.Objects;

@Service
public class DataFetchingService {

    @Autowired
    private RestTemplate restTemplate;

    @Value("${database.address}")
    private String databaseAdress;

    // Helper function to detect the content type from the response headers
    private Class<?> detectResponseType(HttpHeaders headers) {
        String contentType = headers.getContentType().toString();

        if (contentType.contains("application/json")) {
            return JsonNode.class; // Adjust to your expected JSON type
        } else if (contentType.contains("text/plain")) {
            return String.class;
        } else if (contentType.contains("application/xml")) {
            return XMLObject.class; // Adjust to your expected XML type
        }

        // Handle other types if needed, or return a default type
        return Object.class; // Default to a generic Object or String
    }

    // The fetchData method will utilize the response detection
    public ResponseEntity<?> fetchData(URI uri, HttpMethod method) {
        HttpHeaders headers = new HttpHeaders();
        HttpEntity<?> entity = new HttpEntity<>(headers);

        // Perform a pre-flight OPTIONS request to detect the headers
        ResponseEntity<Void> optionsResponse = restTemplate.exchange(uri, HttpMethod.OPTIONS, entity, Void.class);
        HttpHeaders detectedHeaders = optionsResponse.getHeaders();

        // Determine the appropriate response type
        Class<?> responseType = detectResponseType(detectedHeaders);

        // Now request the actual data with the detected response type
        ResponseEntity<?> dataResponse = restTemplate.exchange(uri, method, entity, responseType);

        return dataResponse;
    }

    public ResponseEntity<ResponseModel> fetchSampleData(String apiId, String endpointId) {

        ResponseEntity<ApiModel> response = restTemplate.exchange(
                "http://" + databaseAdress +"/microddbb/api/{apiId}",
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<ApiModel>() {},
                apiId
        );

        ApiModel api = response.getBody();

        EndpointModel endpoint = null;

        if (api == null){
            return ResponseEntity.notFound().build();
        }

        for (EndpointModel endpointTemp : api.getEndpoints()) {

            if (endpointTemp.getEndpointId().toString().equals(endpointId)) {
                endpoint = endpointTemp;
            }

        }

        if (endpoint == null){
            return ResponseEntity.notFound().build();
        }

        String completeUrl = api.getBaseUrl() + endpoint.getUrl();

        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(completeUrl);

        // Check if endpoint uses parameters
        if (!endpoint.getParameters().isEmpty()){
            // Add parameters to url
            for (ParameterModel parameter : endpoint.getParameters())
                builder.queryParam(parameter.getParameter(), parameter.getValue());
        }

        // Build url
        URI uri = builder.build().encode().toUri();

        System.out.println("URI: " + uri.toString());
        System.out.println("METHOD: " + endpoint.getMethod());

        ResponseEntity<?> responseFetch = fetchData(uri, HttpMethod.valueOf(endpoint.getMethod()));

        ResponseEntity<ResponseModel> stored = storeData(responseFetch.getBody(), endpoint);

        return stored;
    }

    public ResponseEntity<ResponseModel> storeData(Object body, EndpointModel endpointModel) {

        ResponseEntity<ResponseModel> storeResponse = null;

        HttpEntity<Object> request = new HttpEntity<>(body);

        if (Objects.equals(endpointModel.getMode(), "latest")) {

            storeResponse = restTemplate.exchange(
                    "http://" + databaseAdress +"/microddbb/response/{endpointId}",
                    HttpMethod.POST,
                    request,
                    new ParameterizedTypeReference<ResponseModel>() {},
                    endpointModel.getEndpointId()
            );

        } else {

            storeResponse = restTemplate.exchange(
                    "http://" + databaseAdress +"/response/historic/{endpointId}",
                    HttpMethod.POST,
                    request,
                    new ParameterizedTypeReference<ResponseModel>() {},
                    endpointModel.getEndpointId()
            );

        }

        return storeResponse;

    }

    public DashboardModel getDashboard(String dashboardId) {

        ResponseEntity<DashboardModel> response = restTemplate.exchange(
                "http://" + databaseAdress +"/microddbb/dashboard/{dashboardId}",
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<DashboardModel>() {},
                dashboardId
        );

        return response.getBody();

    }

    public List<KpiModel> getKpisByEndpoint(String endpointId) {

        ResponseEntity<List<KpiModel>> kpis = restTemplate.exchange(
                "http://" + databaseAdress +"/microddbb/kpi/endpoint/{endpointId}",
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<KpiModel>>() {},
                endpointId
        );

        System.out.println(kpis.getBody());

        return kpis.getBody();

    }
}
