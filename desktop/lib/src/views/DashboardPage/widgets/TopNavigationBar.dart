import 'package:desktop/src/services/DashboardService.dart';
import 'package:desktop/src/views/DashboardPage/widgets/DatasourcesModal/DatasourcesModal.dart';
import 'package:desktop/src/models/DashboardModel.dart';
import 'package:desktop/src/providers/shared_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'dart:ui'; // Import for ImageFilter

class TopNavigationBar extends ConsumerStatefulWidget {
  const TopNavigationBar({Key? key}) : super(key: key);

  @override
  _TopNavigationBarState createState() => _TopNavigationBarState();
}

class _TopNavigationBarState extends ConsumerState<TopNavigationBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardProvider);
    _controller.text = dashboard!.title;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 62, 185, 175).withOpacity(0.2),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(10.0),
                      icon: const Icon(Icons.home, size: 30.0),
                      onPressed: () => _updateAndGoHome(context),
                      visualDensity: VisualDensity.compact,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        height: 30,
                        width: 300,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: _controller,
                          decoration: null,
                          onChanged: (value) => _changeTitle(context, value),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: _showDatasourcesModal,
                      child: const Text('Datasources'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDatasourcesModal() {
    final dashboard = ref.read(dashboardProvider);
    if (dashboard != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DatasourcesModal(initialDashboard: dashboard);
        },
      );
    }
  }

  void _updateAndGoHome(BuildContext context) {
    final dashboard = ref.read(dashboardProvider);
    if (dashboard != null) {
      DashboardService().updateDashboard(dashboard);
      context.go('/home');
    }
  }

  void _changeTitle(BuildContext context, String value) {
    final dashboard = ref.read(dashboardProvider);
    final updatedDashboard = dashboard?.copyWith(title: value);
    if (updatedDashboard != null) {
      ref.read(dashboardProvider.notifier).updateDashboard(updatedDashboard);
    }
  }
}
