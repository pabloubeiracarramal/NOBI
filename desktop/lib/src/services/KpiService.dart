import 'dart:convert';

import 'package:desktop/src/models/KpiModel.dart';
import 'package:desktop/src/services/AuthService.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class KpiService {
  final String baseUrl;

  KpiService(
      {this.baseUrl = 'https://nobi-api-gateway.pabloubeiracarramal.com:8080'});

  Future<List<Kpi>> getKpisByDashbord(int dashboardId) async {
    var token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/microddbb/kpi/$dashboardId'),
      headers: {
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    developer.log('initial load: ', error: response.body);
    print(response.body);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Kpi.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load kpis for dashboard.');
    }
  }

  Future<Kpi> addKpi(Kpi kpi) async {
    var token = await AuthService().getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/microddbb/kpi/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(kpi.toJson()),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Kpi.fromJson(data);
    } else {
      throw Exception('Failed to create kpi.');
    }
  }

  Future<Kpi> updateKpi(Kpi kpi) async {
    print('hehe');

    var token = await AuthService().getToken();

    print('heeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
    print(token);

    final response = await http.put(
      Uri.parse('$baseUrl/microddbb/kpi/${kpi.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(kpi.toJson()),
    );

    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Kpi.fromJson(data);
    } else {
      throw Exception('Failed to create kpi.');
    }
  }

  Future<Kpi> deleteKpi(Kpi kpi) async {
    var token = await AuthService().getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/microddbb/kpi/delete/${kpi.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Kpi.fromJson(data);
    } else {
      throw Exception('Failed to create kpi.');
    }
  }
}
