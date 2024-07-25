package com.example.microbbdd.services;

import com.example.microbbdd.entity.Api;
import com.example.microbbdd.entity.Dashboard;
import com.example.microbbdd.repository.ApiRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class ApiService {

    @Autowired
    private ApiRepository apiRepository;

    public Api addApi(Api newApi) {
        return apiRepository.save(newApi);
    }

    public Api updateApi(Api api){ return apiRepository.save(api); }

    public Api removeApi(Long apiId) {

        Optional<Api> api = apiRepository.findById(apiId);

        if (api.isEmpty()){
            return null;
        }

        apiRepository.delete(api.get());

        return api.get();

    }

    public Api getApi(Long apiId){

        Optional<Api> api = apiRepository.findById(apiId);

        if (api.isEmpty()){
            return null;
        }

        return api.get();

    }
}
