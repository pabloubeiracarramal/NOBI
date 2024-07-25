import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:desktop/src/models/ApiModel.dart';
import 'package:desktop/src/models/EndpointModel.dart';
import 'package:desktop/src/models/KpiModel.dart';
import 'package:desktop/src/models/ResponseModel.dart';
import 'package:desktop/src/providers/shared_providers.dart';
import 'package:desktop/src/services/ResponseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Detail extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const Detail({Key? key, required this.onClose}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends ConsumerState<Detail> {
  late TextEditingController _titleController;
  Api? selectedApi;
  Endpoint? selectedEndpoint;
  String? _kpiTitle;
  dynamic jsonResponse;
  String initialResponse = '{}';
  List<String>? selectedKeys;
  late Response lastResponse;
  bool isLoading = false; // Add this line

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    selectedKeys = [];

    log('INIT STATE');

    final kpi = ref.read(detailContentProvider);
    final dashboard = ref.read(dashboardProvider);

    for (var api in dashboard!.apis) {
      for (var endpoint in api!.endpoints) {
        if (endpoint.endpointId == kpi!.endpointId) {
          selectedApi = api;
          selectedEndpoint = endpoint;
        }
      }
    }

    if (kpi!.responses!.length > 0) {
      jsonResponse = kpi!.responses!.first.data['data'];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Widget buildJsonViewer(dynamic item, endpointId, dashboardId,
      [String currentPath = '']) {
    if (item is Map<String, dynamic>) {
      return Column(
        children: item.entries.map<Widget>((entry) {
          String newPath =
              currentPath + (currentPath.isEmpty ? '' : '.') + entry.key;
          bool isSelected = entry.key == ref.read(detailContentProvider)!.entry;
          return Material(
            color: Colors.transparent,
            child: ListTile(
              title: Text(entry.key),
              subtitle: buildJsonViewer(
                  entry.value, endpointId, dashboardId, newPath),
              selected: isSelected,
              selectedTileColor: Color.fromARGB(17, 0, 104, 116),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              tileColor: Colors.transparent,
              onTap: () {
                print("Selected: $newPath - ${entry.value}");
                selectEntry(entry.key);
                setState(() {
                  if (selectedKeys?.contains(newPath) ?? false) {
                    selectedKeys?.remove(newPath);
                  } else {
                    selectedKeys?.add(newPath);
                  }
                });
              },
            ),
          );
        }).toList(),
      );
    } else if (item is List) {
      return Column(
        children: item.asMap().entries.map<Widget>((entry) {
          String newPath = currentPath + '[' + entry.key.toString() + ']';
          bool isSelected = entry.key == ref.read(detailContentProvider)!.entry;
          return Material(
            color: Colors.transparent,
            child: ListTile(
              title: Text('Index ${entry.key}'),
              subtitle: buildJsonViewer(
                  entry.value, endpointId, dashboardId, newPath),
              selected: isSelected,
              selectedTileColor: Color.fromARGB(17, 0, 104, 116),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              tileColor: Colors.transparent,
              onTap: () {
                print("Selected Index $newPath - ${entry.value}");
                selectEntry(entry.value);
                setState(() {
                  if (selectedKeys?.contains(newPath) ?? false) {
                    selectedKeys?.remove(newPath);
                  } else {
                    selectedKeys?.add(newPath);
                  }
                });
              },
            ),
          );
        }).toList(),
      );
    } else {
      return Text(item.toString(), style: const TextStyle(color: Colors.blue));
    }
  }

  Future<void> updateKPI() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      log('HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEE');
      log(ref.read(detailContentProvider)!.id.toString());
      log(ref.read(detailContentProvider)!.title.toString());
      log(ref.read(detailContentProvider)!.entry.toString());
      log(ref.read(detailContentProvider)!.endpointId.toString());

      ref.read(detailContentProvider.notifier).setKpiResponses([lastResponse]);

      var kpi = ref.read(detailContentProvider);

      if (kpi!.id != null) {
        await ref.read(gridItemsProvider.notifier).updateKpi(kpi!);

        ref.read(detailContentProvider.notifier).removeKpi();
      } else {
        await ref.read(gridItemsProvider.notifier).addItem(kpi!);

        ref.read(detailContentProvider.notifier).removeKpi();
      }

      await ref
          .read(gridItemsProvider.notifier)
          .loadInitialItems(kpi.dashboardId.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // Stop loading
        });
      }
    }
  }

  void changeTitle(String title) {
    log(title);
    ref.read(detailContentProvider.notifier).setKpiTitle(title);
  }

  void selectApi(Api api) {
    setState(() {
      selectedApi = api;
      selectedEndpoint = null;
      jsonResponse = [];
    });
    ref.read(detailContentProvider.notifier).setKpiApi(api);
  }

  void selectEndpoint(Endpoint endpoint) {
    setState(() {
      selectedEndpoint = endpoint;
    });
    ref.read(detailContentProvider.notifier).setKpiEndpoint(endpoint);

    ResponseService()
        .getSampleResponse(
      selectedApi!.id.toString(),
      endpoint.endpointId.toString(),
    )
        .then(
      (retrievedResponse) {
        setState(() {
          jsonResponse = retrievedResponse.data.entries.first.value;
          lastResponse = retrievedResponse;
        });
      },
    );
  }

  void selectEntry(String entry) {
    ref.read(detailContentProvider.notifier).setKpiEntry(entry);
  }

  @override
  Widget build(BuildContext context) {
    final kpi = ref.watch(detailContentProvider);
    final dashboard = ref.watch(dashboardProvider);

    print('BUILD TRIGGERED');

    if (kpi != null && _kpiTitle == null) {
      _kpiTitle = kpi.title;
      _titleController.text = kpi.title!;
    }

    log(kpi!.endpointId.toString());
    log(selectedApi.toString());
    log(selectedEndpoint.toString());

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 62, 185, 175).withOpacity(0.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            kpi?.title ?? 'No KPI title',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: widget.onClose,
                            icon: const Icon(Icons.close, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Title",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          isDense: true,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color.fromARGB(200, 255, 255, 255),
                        ),
                        onChanged: (value) {
                          changeTitle(value);
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "API",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Color.fromARGB(200, 255, 255, 255),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<Api>(
                          hint: const Text("Select API"),
                          underline: const SizedBox(),
                          isExpanded: true,
                          value: selectedApi,
                          onChanged: (Api? newApi) {
                            selectApi(newApi!);
                          },
                          items: dashboard?.apis
                                  .map<DropdownMenuItem<Api>>((Api api) {
                                return DropdownMenuItem<Api>(
                                  value: api,
                                  child: Text(api.name),
                                );
                              }).toList() ??
                              [],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Endpoint",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Color.fromARGB(200, 255, 255, 255),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<Endpoint>(
                          hint: const Text("Select Endpoint"),
                          underline: const SizedBox(),
                          isExpanded: true,
                          value: selectedEndpoint,
                          onChanged: (Endpoint? newEndpoint) {
                            selectEndpoint(newEndpoint!);
                          },
                          items: selectedApi?.endpoints
                                  .map<DropdownMenuItem<Endpoint>>(
                                      (Endpoint endpoint) {
                                return DropdownMenuItem<Endpoint>(
                                  value: endpoint,
                                  child: Text(endpoint.url),
                                );
                              }).toList() ??
                              [],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select Entry',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromARGB(100, 255, 255, 255),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 600,
                                  width: double.infinity,
                                  child: SingleChildScrollView(
                                    child: buildJsonViewer(
                                      jsonResponse,
                                      selectedEndpoint?.endpointId,
                                      dashboard?.dashboardId,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    updateKPI();
                                  },
                            child: isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text('Save'),
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 104, 116),
                              foregroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
