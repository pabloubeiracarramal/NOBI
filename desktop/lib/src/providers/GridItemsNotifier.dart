import 'dart:convert';
import 'dart:developer' as developer;

import 'package:desktop/src/models/KpiModel.dart';
import 'package:desktop/src/models/ResponseModel.dart';
import 'package:desktop/src/services/KpiService.dart';
import 'package:desktop/src/views/DashboardPage/widgets/Graphs/Kpi.dart';
import 'package:desktop/src/views/DashboardPage/widgets/Grid/GridItem.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: falla cuando lo creas e inmediatamente lo mueves

class GridItemsNotifier extends StateNotifier<List<GridItem>> {
  GridItemsNotifier() : super([]);

  Future<void> loadInitialItems(String dashboardId) async {
    List<Kpi> kpis =
        await KpiService().getKpisByDashbord(int.parse(dashboardId));

    developer.log('initial load: ', error: kpis);

    List<GridItem> gridItems = kpis.map((kpi) {
      List<int> position = jsonDecode(kpi.position!).cast<int>();

      var value = null;

      if (kpi.responses!.isNotEmpty) {
        value = getNestedValue(
          kpi.responses?[0].data['data'],
          kpi!.entry!,
        );
      }

      return GridItem(
        label: kpi.title!,
        columnStart: position[0],
        rowStart: position[1],
        columnSpan: position[2],
        rowSpan: position[3],
        child: KpiWidget(kpi: kpi, value: value),
        id: kpi.id!,
        kpi: kpi,
      );
    }).toList();

    state = gridItems;
  }

  Future<void> addItem(Kpi kpi) async {
    Kpi storedKpi = await KpiService().addKpi(kpi);

    developer.log('storedKpi', error: jsonEncode(storedKpi));
    developer.log('storedKpiId', error: jsonEncode(storedKpi.id));

    List<int> position = jsonDecode(storedKpi.position!).cast<int>();
    GridItem item = GridItem(
      label: storedKpi.title!,
      columnStart: position[0],
      rowStart: position[1],
      columnSpan: position[2],
      rowSpan: position[3],
      child: Text(storedKpi.entry.toString()),
      id: storedKpi.id!,
      kpi: storedKpi,
    );
    state = [...state, item];
  }

  dynamic getNestedValue(Map<String, dynamic> map, String path) {
    // Split the dot-separated path into individual keys
    List<String> keys = path.split('.');

    // Traverse the map using each key
    dynamic current = map;
    for (String key in keys) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        // If any key is missing, return null or handle error as needed
        return null;
      }
    }

    // Return the found value
    return current;
  }

  void updateResponseForKpi(int kpiId, Response updatedResponse) {
    List<GridItem> updatedItems = state.map((gridItem) {
      if (gridItem.kpi != null && gridItem.kpi!.id == kpiId) {
        // Ensure the KPI has an initialized response set
        List<Response> responses = gridItem.kpi!.responses ?? <Response>[];

        // Remove the old response, if it exists
        responses.removeWhere(
          (r) => r.responseId == updatedResponse.responseId,
        );

        // Add the updated or new response
        responses.add(updatedResponse);

        // Update the KPI's responses and create a new GridItem with updated KPI
        gridItem.kpi!.responses = responses;

        // Get value
        var value = getNestedValue(
          updatedResponse.data['data'],
          gridItem.kpi!.entry!,
        );

        gridItem.child = KpiWidget(kpi: gridItem.kpi!, value: value);

        return gridItem.copyWith(kpi: gridItem.kpi);
      }
      return gridItem;
    }).toList();
    state = updatedItems;

    print(state);
  }

  Future<void> updateItemPosition(
      String id, int newColumnStart, int newRowStart) async {
    print(id);
    var items = [...state];
    var item = items.firstWhere((item) => '${item.id}' == id);
    if (item != null) {
      item = item.copyWith(columnStart: newColumnStart, rowStart: newRowStart);
      List<int> position = jsonDecode(item.kpi!.position!).cast<int>();
      position[0] = newColumnStart;
      position[1] = newRowStart;
      item.kpi!.position = position.toString();
      await KpiService().updateKpi(item.kpi!);
      state = items.map((i) => '${i.id}' == id ? item : i).toList();
    }
  }

  Future<void> updateItemSize(
      String id, int newColumnSpan, int newRowSpan) async {
    var items = [...state];
    var item = items.firstWhere((item) => '${item.id}' == id);
    if (item != null) {
      item = item.copyWith(columnSpan: newColumnSpan, rowSpan: newRowSpan);
      List<int> position = jsonDecode(item.kpi!.position!).cast<int>();
      position[2] = newColumnSpan;
      position[3] = newRowSpan;
      item.kpi!.position = position.toString();
      Kpi updatedKpi = await KpiService().updateKpi(item.kpi!);
      state = items.map((i) => '${i.id}' == id ? item : i).toList();
    }
  }

  Future<void> deleteKpi(String id) async {
    var items = [...state];
    var item = items.firstWhere((item) => '${item.id}' == id);
    items.remove(item);
    KpiService().deleteKpi(item.kpi!);
    state = items;
  }

  Future<void> updateKpi(Kpi updatedKpi) async {
    print('ch1');
    var items = [...state];
    print('ch2');
    var item = items
        .firstWhere((item) => '${item.kpi!.id}' == updatedKpi.id.toString());
    print('ch3');
    Kpi retrievedKpi = await KpiService().updateKpi(updatedKpi);
    item = item.copyWith(kpi: retrievedKpi);
    state = items.map((i) => '${i.id}' == updatedKpi.id ? item : i).toList();
  }
}
