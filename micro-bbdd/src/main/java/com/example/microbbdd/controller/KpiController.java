package com.example.microbbdd.controller;

import com.example.microbbdd.entity.Kpi;
import com.example.microbbdd.services.KpiService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/microddbb/kpi")
public class KpiController {

    @Autowired
    private KpiService kpiService;

    @GetMapping("/ok")
    public ResponseEntity<String> isOk() throws Exception {
        return new ResponseEntity<>("Everything is allright.", HttpStatus.OK);
    }

    @GetMapping("/endpoint/{endpointId}")
    public ResponseEntity<List<Kpi>> getKpisForEndpoint(@PathVariable Long endpointId) {
        List<Kpi> kpis = kpiService.retrieveEndpointKpis(endpointId);
        return new ResponseEntity<>(kpis, HttpStatus.OK);
    }

    @GetMapping("/{dashboardId}")
    public ResponseEntity<List<Kpi>> getDashboardKpis(@PathVariable Long dashboardId) {
        List<Kpi> kpis = kpiService.retrieveKpisByDashboard(dashboardId);
        ResponseEntity response = new ResponseEntity<>(kpis, HttpStatus.OK);
        System.out.println(response);
//        System.out.println(kpis.get(0));
        return new ResponseEntity<>(kpis, HttpStatus.OK);
    }

    @GetMapping("/id/{kpiId}")
    public ResponseEntity<Kpi> getKpi(@PathVariable Long kpiId) {
        Kpi kpi = kpiService.retrieveKpiById(kpiId);
        return new ResponseEntity<>(kpi, HttpStatus.OK);
    }

    @PostMapping("/add")
    public ResponseEntity<Kpi> addKpi(@RequestBody Kpi newKpi) {
        System.out.println("NEW KPIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
        System.out.println(newKpi);
        Kpi kpi = kpiService.addKpi(newKpi);
        return new ResponseEntity<>(kpi, HttpStatus.OK);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Kpi> updateKpi(@PathVariable Long id, @RequestBody Kpi kpiDetails) {
        Kpi updatedKpi = kpiService.updateKpi(id, kpiDetails);
        return new ResponseEntity<>(updatedKpi, HttpStatus.OK);
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Kpi> deleteKpi(@PathVariable Long id) {
        Kpi deletedKpi = kpiService.deleteKpi(id);
        return  new ResponseEntity<>(deletedKpi, HttpStatus.OK);
    }



}
