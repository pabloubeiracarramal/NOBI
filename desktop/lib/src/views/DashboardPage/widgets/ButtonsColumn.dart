import 'dart:ui'; // Ensure you have this import for ImageFilter
import 'package:desktop/src/models/KpiModel.dart';
import 'package:desktop/src/models/ResponseModel.dart';
import 'package:desktop/src/providers/shared_providers.dart';
import 'package:desktop/src/services/DataService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // For ConsumerStatefulWidget and WidgetRef
import 'package:desktop/src/views/DashboardPage/widgets/GraphConfigModal/GraphConfigModal.dart'; // For GraphConfigModal

class ButtonsColumn extends ConsumerStatefulWidget {
  @override
  _ButtonsColumnState createState() => _ButtonsColumnState();
}

class _ButtonsColumnState extends ConsumerState<ButtonsColumn> {
  Color getStatusColor(String status) {
    if (status == "Running") {
      return Colors.green;
    }

    if (status == "Stopped") {
      return Colors.red;
    }

    if (status == "Running partially") {
      return Colors.orange;
    }

    return Colors.grey;
  }

  void createKpi() {
    List<Response> responses = [];

    Kpi newKpi = Kpi(
      title: 'KPI',
      position: "[2000, 2000, 4, 3]",
      entry: null,
      endpointId: null,
      dashboardId: ref.read(dashboardProvider)!.dashboardId,
      responses: responses,
      type: 'kpi',
    );

    // ref.read(gridItemsProvider.notifier).addItem(newKpi);

    ref.read(detailContentProvider.notifier).setKpi(newKpi);
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(statusProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: getStatusColor(status),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Text(status),
            ],
          ),
        ),
        SizedBox(height: 12.5),
        _buildFrostedButton(
          context: context,
          icon: Icons.add,
          size: 32.0,
          onPressed: () {
            createKpi();
          },
        ),
        SizedBox(height: 10),
        _buildFrostedButton(
          context: context,
          icon: Icons.adjust,
          size: 32.0,
          onPressed: () {
            ref.read(transformationControllerProvider.notifier).centerGrid();
          },
        ),
        SizedBox(height: 10),
        _buildFrostedButton(
          context: context,
          icon: Icons.play_arrow,
          size: 32.0,
          onPressed: () {
            DataService().startDashboard(
              ref.read(dashboardProvider)!.dashboardId.toString(),
            );
          },
        ),
        SizedBox(height: 10),
        _buildFrostedButton(
          context: context,
          icon: Icons.stop,
          size: 32.0,
          onPressed: () {
            DataService().stopDashboard(
              ref.read(dashboardProvider)!.dashboardId.toString(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFrostedButton({
    required BuildContext context,
    required IconData icon,
    double? size,
    required VoidCallback onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: Container(
          color: Color.fromARGB(255, 62, 185, 175).withOpacity(0.2),
          child: IconButton(
            padding: const EdgeInsets.all(8),
            onPressed: onPressed,
            icon: Icon(icon, size: size),
          ),
        ),
      ),
    );
  }
}
