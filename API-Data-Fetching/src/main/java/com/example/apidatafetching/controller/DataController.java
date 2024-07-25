package com.example.apidatafetching.controller;

import com.example.apidatafetching.service.DynamicTaskSchedulingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class DataController {

    private static final Logger logger = LoggerFactory.getLogger(DataController.class);

    @Autowired
    private SimpMessagingTemplate template;

    public void sendData(Object data) {
        logger.info("Sending data: {}", data);
        template.convertAndSend("/data/kpi", data);
    }

    public void sendStatus(String status) {
        logger.info("Sending status: {}", status);
        template.convertAndSend("/data/status", status);
    }

}
