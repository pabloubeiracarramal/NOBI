package com.example.microbbdd.services;

import com.example.microbbdd.entity.Kpi;
import com.example.microbbdd.entity.Response;
import com.example.microbbdd.repository.KpiRepository;
import com.example.microbbdd.repository.ResponseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class KpiService {

    @Autowired
    private KpiRepository kpiRepository;

    @Autowired
    private ResponseRepository responseRepository;

    public List<Kpi> retrieveEndpointKpis(Long endpointId) {
        List<Kpi> kpis = kpiRepository.findKpisByEndpointId(endpointId);
        return kpis;
    }

    public List<Kpi> retrieveKpisByDashboard(Long dashboardId) {
        List<Kpi> kpis = kpiRepository.findKpisByDashboardId(dashboardId);
        return kpis;
    }

    public Kpi retrieveKpiById(Long kpiId) {
        Kpi kpi = kpiRepository.findKpiByKpiId(kpiId);
        return kpi;
    }

    @Transactional
    public Kpi addKpi(Kpi kpi) {
        List<Response> responses = new ArrayList<>(kpi.getResponses());

        System.out.println(responses);

        kpi.setResponses(new ArrayList<>());

        Kpi storedKpi = kpiRepository.save(kpi);

        System.out.println("KPI");
        System.out.println(storedKpi);
        System.out.println(storedKpi.getResponses());

        for (Response response: responses) {
            Response retrievedResponse = responseRepository.findById(response.getResponseId()).get();

            List<Kpi> kpis = retrievedResponse.getKpis();

            if (!kpis.contains(storedKpi)){
                kpis.add(storedKpi);
            }

            retrievedResponse.setKpis(kpis);
            Response updatedResponse = responseRepository.save(retrievedResponse);
            storedKpi.getResponses().add(updatedResponse);
        }

        System.out.println("RESPONSES");
        System.out.println(responses);

        System.out.println("KPI");
        System.out.println(storedKpi);
        System.out.println(storedKpi.getResponses());

        return storedKpi;
    }


    public Kpi updateKpi(Long id, Kpi kpiDetails) {
        Kpi kpi = kpiRepository.findById(id).get();
        kpi.setPosition(kpiDetails.getPosition());
        kpi.setEntry(kpiDetails.getEntry());
        kpi.setTitle(kpiDetails.getTitle());
        kpi.setEndpointId(kpiDetails.getEndpointId());
        return kpiRepository.save(kpi);
    }

    public Kpi deleteKpi(Long id) {
        Kpi retrievedKpi = kpiRepository.findKpiByKpiId(id);
        kpiRepository.delete(retrievedKpi);
        return retrievedKpi;
    }
}
