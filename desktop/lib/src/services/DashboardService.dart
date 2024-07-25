import 'dart:convert';
import 'dart:developer';

import 'package:desktop/src/models/DashboardModel.dart';
import 'package:desktop/src/services/AuthService.dart';
import 'package:http/http.dart' as http;

class DashboardService {
  final String baseUrl;

  DashboardService(
      {this.baseUrl =
          'https://nobi-api-gateway.pabloubeiracarramal.com:8080/microddbb/dashboard'});

  // ENDPOINT: GET /dashboards
  Future<List<Dashboard>> fetchDashboardsUser() async {
    var token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Dashboard.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load dashboards from user.');
    }
  }

  // ENDPOINT: GET /dashboard/{dashboardId}
  Future<Dashboard> getDashboardById(String dashboardId) async {
    var token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/$dashboardId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Dashboard.fromJson(data);
    } else {
      throw Exception('Failed to load dashboard details.');
    }
  }

  // ENDPOINT: POST /dashboard
  Future<Dashboard> addDashboard(Dashboard dashboardDetail) async {
    var token = await AuthService().getToken();

    dashboardDetail.userId = (await AuthService().getUid())!;

    print("UID: ");
    print(dashboardDetail.userId);

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(dashboardDetail.toJson()),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Dashboard.fromJson(data);
    } else {
      throw Exception('Failed to create dashboard.');
    }
  }

  // Future<Dashboard> deleteApiFromDashboard(
  //     double dashboardId, double apiId) async {
  //   var token = await AuthService().getToken();

  //   final response = await http.post(
  //     Uri.parse('$baseUrl/manager/dashboard/delete/api/$dashboardId/$apiId'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> data = json.decode(response.body);
  //     return Dashboard.fromJson(data);
  //   } else {
  //     throw Exception('Failed to create dashboard.');
  //   }
  // }

  Future<Dashboard> deleteDashboard(double dashboardId, double apiId) async {
    var token = await AuthService().getToken();

    final response = await http.delete(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Dashboard.fromJson(data);
    } else {
      throw Exception('Failed to create dashboard.');
    }
  }

  Future<Dashboard> updateDashboard(Dashboard updatedDashboard) async {
    var token = await AuthService().getToken();

    log(json.encode(updatedDashboard.apis));

    final response = await http.put(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedDashboard.toJson()),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Dashboard.fromJson(data);
    } else {
      throw Exception('Failed to update dashboard.');
    }
  }
}
