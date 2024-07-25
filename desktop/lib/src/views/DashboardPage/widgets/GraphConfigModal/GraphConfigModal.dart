import 'dart:math';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:desktop/src/models/ApiModel.dart';
import 'package:desktop/src/models/EndpointModel.dart';
import 'package:desktop/src/models/KpiModel.dart';
import 'package:desktop/src/models/ResponseModel.dart';
import 'package:desktop/src/services/KpiService.dart';
import 'package:desktop/src/services/ResponseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desktop/src/providers/shared_providers.dart';
import 'package:desktop/src/views/DashboardPage/widgets/Grid/GridItem.dart';
import 'dart:convert';

class GraphConfigModal extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GraphConfigModalState();
}

class _GraphConfigModalState extends ConsumerState<GraphConfigModal> {
  Api? selectedApi;
  Endpoint? selectedEndpoint;
  List<String>? selectedKeys;
  dynamic jsonResponse;
  String sampleResponse =
      '{ "test": [ "item1", "item2" ], "name":"John", "age":30, "city":"New York", "details": {"married": false, "children": 2}}';
  late Response lastResponse;

  @override
  void initState() {
    super.initState();
    jsonResponse = jsonDecode(sampleResponse);
    selectedKeys = [];
  }

  void addKpi(entry, endpointId, dashboardId, position, title) {
    print("Vlues ${position} - ${title}");
    List<Response> responses = [];

    responses.add(lastResponse);

    Kpi kpi = Kpi(
      title: title,
      position: "[2000, 2000, 4, 3]",
      entry: entry,
      endpointId: endpointId,
      dashboardId: int.parse(dashboardId),
      responses: responses,
      type: 'kpi',
    );

    developer.log('log me', name: 'my.app.category');
    developer.log('kpi', error: jsonEncode(kpi));
    developer.log('res', error: jsonEncode(responses));

    print(kpi.responses!.first.data.entries.toString());

    ref.read(gridItemsProvider.notifier).addItem(kpi);
  }

  void selectEndpoint(newValue) {
    ResponseService()
        .getSampleResponse(
      selectedApi!.id.toString(),
      newValue.endpointId.toString(),
    )
        .then(
      (retrievedResponse) {
        setState(() {
          jsonResponse = retrievedResponse.data.entries.first.value;
          lastResponse = retrievedResponse;
          print('RESPONSE: ${retrievedResponse}');
          print('JSON RESPONSE: ${jsonResponse}');
        });
      },
    );
  }

  Widget buildJsonViewer(dynamic item, endpointId, dashboardId,
      [String currentPath = '']) {
    if (item is Map<String, dynamic>) {
      return Column(
        children: item.entries.map<Widget>((entry) {
          String newPath =
              currentPath + (currentPath.isEmpty ? '' : '.') + entry.key;
          return ListTile(
            title: Text(entry.key),
            subtitle:
                buildJsonViewer(entry.value, endpointId, dashboardId, newPath),
            onTap: () {
              print("Selected: $newPath - ${entry.value}");
              setState(() {
                selectedKeys?.add(newPath);
              });
            },
          );
        }).toList(),
      );
    } else if (item is List) {
      return Column(
        children: item.asMap().entries.map<Widget>((entry) {
          String newPath = currentPath + '[' + entry.key.toString() + ']';
          return ListTile(
            title: Text('Index ${entry.key}'),
            subtitle:
                buildJsonViewer(entry.value, endpointId, dashboardId, newPath),
            onTap: () {
              print("Selected Index $newPath - ${entry.value}");
              setState(() {
                selectedKeys?.add(newPath);
              });
            },
          );
        }).toList(),
      );
    } else {
      return Text(item.toString(), style: TextStyle(color: Colors.blue));
    }
  }

  @override
  Widget build(BuildContext context) {
    final gridItems = ref.watch(gridItemsProvider);
    final dashboard = ref.watch(dashboardProvider);
    final store = ref.watch(dataExplorerStoreProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: Dialog(
          backgroundColor: Color.fromARGB(255, 226, 255, 253).withOpacity(0.85),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KPI Configuration', style: TextStyle(fontSize: 20)),
                  Row(
                    children: [
                      Column(
                        children: [
                          DropdownButton<Api>(
                            value: selectedApi,
                            hint: Text("Select API"),
                            onChanged: (Api? newValue) {
                              setState(() {
                                selectedApi = newValue;
                                selectedEndpoint =
                                    null; // Reset endpoint on API change
                              });
                            },
                            items: dashboard!.apis
                                .map<DropdownMenuItem<Api>>((Api api) {
                              return DropdownMenuItem<Api>(
                                value: api,
                                child: Text(api.name),
                              );
                            }).toList(),
                          ),
                          DropdownButton<Endpoint>(
                            value: selectedEndpoint,
                            hint: Text("Select Endpoint"),
                            onChanged: (Endpoint? newValue) {
                              setState(() {
                                selectedEndpoint = newValue;
                              });

                              if (newValue != null) {
                                selectEndpoint(newValue);
                              }
                            },
                            items: selectedApi?.endpoints
                                .map<DropdownMenuItem<Endpoint>>(
                                    (Endpoint endpoint) {
                              return DropdownMenuItem<Endpoint>(
                                value: endpoint,
                                child: Text(endpoint.url),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      // HERE GOES A SELECTION FOR THE JSON KEY YOU WANT TO DISPLAY:
                      Expanded(
                        child: SizedBox(
                          height:
                              300, // Set a fixed height or make it dynamic as per your UI design
                          child: SingleChildScrollView(
                            child: buildJsonViewer(
                              jsonResponse,
                              selectedEndpoint?.endpointId,
                              dashboard.dashboardId,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedKeys != null &&
                              selectedKeys!.isNotEmpty &&
                              selectedEndpoint != null) {
                            String lastSelectedKey = selectedKeys!.last;
                            int endpointId = selectedEndpoint!.endpointId;
                            String dashboardId =
                                dashboard.dashboardId.toString();
                            addKpi(lastSelectedKey, endpointId, dashboardId,
                                "[2000, 2000, 4, 3]", "KPI");

                            selectedKeys!.clear();
                            Navigator.of(context).pop();
                          } else {
                            print("No selection made or missing information!");
                          }
                        },
                        child: Text('Create'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
