package com.example.apidatafetching.controller;

import com.example.apidatafetching.service.DynamicTaskSchedulingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;

@Controller
public class WebSocketController {

    @Autowired
    DynamicTaskSchedulingService dynamicTaskSchedulingService;

    @Autowired
    DataController dataController;

    @MessageMapping("/someEndpoint")
    public void handleMessagesFromClient(@Payload String dashboardId) {
        System.out.println("Connected: " + dashboardId);
        String status = dynamicTaskSchedulingService.statusDashboardTask(dashboardId);
        dataController.sendStatus(status);
    }

}
