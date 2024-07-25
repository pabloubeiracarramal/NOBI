package com.example.apidatafetching.utilities;

import com.example.apidatafetching.controller.DataController;
import com.example.apidatafetching.entity.EndpointModel;
import com.example.apidatafetching.entity.KpiModel;
import com.example.apidatafetching.entity.ResponseModel;
import com.example.apidatafetching.service.DataFetchingService;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;

import java.net.URI;
import java.util.List;
import java.util.Map;

public class TaskRunnable implements Runnable {

    private final DataFetchingService dataFetchingService;

    private final DataController dataController;

    private URI uri;
    private HttpMethod method;

    private EndpointModel endpointModel;

    public TaskRunnable(DataFetchingService dataFetchingService, DataController dataController, EndpointModel endpointModel, URI uri, HttpMethod method) {
        this.dataFetchingService = dataFetchingService;
        this.dataController = dataController;
        this.uri = uri;
        this.method = method;
        this.endpointModel = endpointModel;
    }

    @Override
    public void run() {

        ResponseEntity<?> response = dataFetchingService.fetchData(uri, method);

        ResponseEntity<ResponseModel> stored = dataFetchingService.storeData(response.getBody(), endpointModel);

        List<KpiModel> kpis = dataFetchingService.getKpisByEndpoint(endpointModel.getEndpointId().toString());

        stored.getBody().setKpis(kpis);

        System.out.println(stored.getBody());

        System.out.println("KPI: " + kpis.get(0));



        if (kpis != null) {
            dataController.sendData(stored.getBody());
        }

    }
}
