package com.example.apidatafetching.service;

import com.example.apidatafetching.controller.DataController;
import com.example.apidatafetching.entity.ApiModel;
import com.example.apidatafetching.entity.DashboardModel;
import com.example.apidatafetching.entity.EndpointModel;
import com.example.apidatafetching.entity.ParameterModel;
import com.example.apidatafetching.utilities.TaskRunnable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;

@Service
public class DynamicTaskSchedulingService {

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private DataFetchingService dataFetchingService;

    @Autowired
    private DataController dataController;

    private final TaskScheduler taskScheduler;
    private final Map<Long, ScheduledFuture<?>> scheduledTasks = new ConcurrentHashMap<>();

    public DynamicTaskSchedulingService(TaskScheduler taskScheduler) {
        this.taskScheduler = taskScheduler;
    }

    public DashboardModel scheduleDashboardTask(String dashboardId) {

        // Retrieve dashboard from db microservice
        DashboardModel dashboard = dataFetchingService.getDashboard(dashboardId);

        // Check if dashboard exists
        if (dashboard == null){
            return null;
        }

        // Check if dashboard has any API
        if (dashboard.getApis().isEmpty())
            return null;

        // Iterate over dashboard apis
        for (ApiModel api : dashboard.getApis()){

            System.out.println("API: " + api.getId());

            // TODO: do something better than a break
            // Check if api has endpoints
            if (api.getEndpoints().isEmpty())
                break;

            // Iterate over api endpoints
            for (EndpointModel endpoint : api.getEndpoints()){

                System.out.println("  E: " + endpoint.getUrl());

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

                System.out.println( "Method: " + endpoint.getMethod());
                System.out.println(HttpMethod.valueOf(endpoint.getMethod()));

                // Create task for the endpoint
                TaskRunnable task = new TaskRunnable(dataFetchingService, dataController, endpoint, uri, HttpMethod.valueOf(endpoint.getMethod()));

                // Schedule task
                ScheduledFuture<?> scheduledTask = taskScheduler.scheduleWithFixedDelay(task, endpoint.getWaitTime());

                // Store task
                scheduledTasks.put(endpoint.getEndpointId(), scheduledTask);

            }

        }

        return  dashboard;

    }

    public DashboardModel stopDashboardTask(String dashboardId) {

            // Retrieve dashboard from db microservice
            DashboardModel dashboard = dataFetchingService.getDashboard(dashboardId);

            // Check if dashboard exists
            if (dashboard == null){
                return null;
            }

            // Check if dashboard has any API
            if (dashboard.getApis().isEmpty())
                return null;

            // Iterate over dashboard apis
            for (ApiModel api : dashboard.getApis()){

                // TODO: do something better than a break
                // Check if api has endpoints
                if (api.getEndpoints().isEmpty())
                    break;

                // Iterate over api endpoints
                for (EndpointModel endpoint : api.getEndpoints()){

                    // Retrieve task
                    boolean taskExists = scheduledTasks.containsKey(endpoint.getEndpointId());

                    // Check if task is running
                    if (!taskExists)
                        break;

                    // Retrieve task
                    ScheduledFuture<?> scheduledTask = scheduledTasks.get(endpoint.getEndpointId());

                    // Stop task
                    scheduledTask.cancel(true);

                    // Remove task from map
                    scheduledTasks.remove(endpoint.getEndpointId());

                }

            }


        return dashboard;

    }

    public String statusDashboardTask(String dashboardId) {

        // Retrieve dashboard from db microservice
        DashboardModel dashboard = dataFetchingService.getDashboard(dashboardId);

        // STATUS
        boolean allRunning = true;
        boolean someRunning = false;

        // Check if dashboard exists
        if (dashboard == null){
            return null;
        }

        // Check if dashboard has any API
        if (dashboard.getApis().isEmpty()){
            return "Dashboard doesn't have any APIs";
        }

        // Iterate over dashboard apis
        for (ApiModel api : dashboard.getApis()){

            // TODO: do something better than a break
            // Check if api has endpoints
            if (api.getEndpoints().isEmpty())
                break;

            // Iterate over api endpoints
            for (EndpointModel endpoint : api.getEndpoints()){

                // Retrieve task
                boolean taskExists = scheduledTasks.containsKey(endpoint.getEndpointId());

                // Check if task is running
                if (!taskExists){
                    allRunning = false;
                    break;
                } else {
                    someRunning = true;
                }


            }

        }

        if (allRunning){
            return "Running";
        } else {
            if (someRunning){
                return "Running partially";
            } else {
                return "Stopped";
            }
        }

    }

}
