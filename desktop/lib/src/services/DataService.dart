import 'dart:convert';
import 'dart:developer';
import 'package:desktop/src/models/KpiModel.dart';
import 'package:desktop/src/models/ResponseModel.dart';
import 'package:desktop/src/providers/shared_providers.dart';
import 'package:desktop/src/services/AuthService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:developer' as developer;

class DataService {
  static final DataService _instance = DataService._internal();
  final String baseUrl;
  WebSocketChannel? channel;
  WidgetRef? ref;

  // Private constructor
  DataService._internal(
      {this.baseUrl = 'https://nobi-api-gateway.pabloubeiracarramal.com:8080'});

  // Factory constructor to access the instance
  factory DataService() {
    return _instance;
  }

  void setRef(WidgetRef ref) {
    this.ref = ref;
  }

  void startDashboard(String? dashboardId) async {
    var token = await AuthService().getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/apidatafetching/dashboard/start/$dashboardId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      log(response.body);
    }
  }

  void stopDashboard(String? dashboardId) async {
    var token = await AuthService().getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/apidatafetching/dashboard/stop/$dashboardId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      log(response.body);
    }
  }

  void connectToWebSocket() async {
    print('Connecting');

    // Get the token from your API service
    final String? token = await AuthService().getToken();

    if (token == null) {
      print('Token is null, cannot connect to WebSocket.');
      return;
    }

    // Append the token as a query parameter to the WebSocket URL
    final String wsUrl =
        'wss://nobi-data-fetching.pabloubeiracarramal.com:8083/data-fetching?token=$token';

    late StompClient stompClient;
    stompClient = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: (StompFrame frame) {
          print('Connected to WS');
          stompClient.subscribe(
            destination: '/data/kpi',
            callback: (frame) {
              var jsonData = json.decode(frame.body!);

              List<dynamic> kpiList = jsonData['kpis'];

              print('KPI LIST');
              print(kpiList);
              print('');

              for (var kpi in ref!.read(gridItemsProvider)) {
                var kpiInList = kpiList.firstWhere(
                    (k) => k["kpiId"] == kpi.kpi!.id,
                    orElse: () => null);

                if (kpiInList != null) {
                  Response response = Response.fromJson(jsonData);
                  print(kpi);
                  ref!
                      .read(gridItemsProvider.notifier)
                      .updateResponseForKpi(kpi.kpi!.id!, response);
                }
              }

              // ref!
              //     .read(gridItemsProvider.notifier)
              //     .updateResponseForKpi(kpiId, response);
            },
          );

          stompClient.subscribe(
            destination: '/data/status',
            callback: (frame) {
              print(
                  'STATUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUS');
              print(frame.body);
              ref!.read(statusProvider.notifier).updateStatus(frame.body!);
            },
          );

          stompClient.send(
            destination: '/data/someEndpoint',
            body: "6",
          );
        },
        onStompError: (StompFrame frame) {
          print('STOMP Error: ${frame.body}');
          ref!.read(statusProvider.notifier).updateStatus("Error");
        },
        onWebSocketError: (dynamic error) {
          print('WebSocket Error: $error');
          if (error is WebSocketChannelException) {
            print('Detailed error: ${error.message}');
          }
        },
      ),
    );

    stompClient.activate();
  }

  void disconnectFromWebSocket() {
    channel?.sink.close();
  }
}
