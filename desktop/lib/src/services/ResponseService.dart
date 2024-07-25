import 'dart:convert';
import 'package:desktop/src/models/ResponseModel.dart';
import 'package:desktop/src/services/AuthService.dart';
import 'package:http/http.dart' as http;

class ResponseService {
  final String baseUrl;

  ResponseService(
      {this.baseUrl = 'https://nobi-api-gateway.pabloubeiracarramal.com:8080'});

  Future<Response> getResponseByEndpointId(int endpointId) async {
    var token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/microddbb/response/$endpointId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Response.fromJson(data);
    } else {
      throw Exception('Failed to fetch responses.');
    }
  }

  Future<dynamic> getSampleResponse(String apiId, String endpointId) async {
    var token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/apidatafetching/sample/$apiId/$endpointId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Response.fromJson(data);
    } else {
      throw Exception('Failed to fetch responses.');
    }
  }
}
