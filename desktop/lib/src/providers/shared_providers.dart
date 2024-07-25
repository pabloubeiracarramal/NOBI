import 'package:desktop/src/models/KpiModel.dart';
import 'package:desktop/src/providers/DetailContentNotifier.dart';
import 'package:desktop/src/providers/StatusNotifier.dart';
import 'package:desktop/src/views/DashboardPage/widgets/Grid/GridItem.dart';
import 'package:desktop/src/providers/DashboardNotifier.dart';
import 'package:desktop/src/providers/GridItemsNotifier.dart';
import 'package:desktop/src/providers/TransformationNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_data_explorer/json_data_explorer.dart';
import '../models/DashboardModel.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, Dashboard?>((ref) {
  return DashboardNotifier();
});

final gridItemsProvider =
    StateNotifierProvider<GridItemsNotifier, List<GridItem>>((ref) {
  return GridItemsNotifier();
});

final transformationControllerProvider =
    StateNotifierProvider<TransformationNotifier, TransformationController>(
        (ref) {
  return TransformationNotifier();
});

final dataExplorerStoreProvider = Provider<DataExplorerStore>((ref) {
  return DataExplorerStore();
});

final statusProvider = StateNotifierProvider<StatusNotifier, String>((ref) {
  return StatusNotifier();
});

final detailContentProvider =
    StateNotifierProvider<DetailContentNotifier, Kpi?>((ref) {
  return DetailContentNotifier();
});
