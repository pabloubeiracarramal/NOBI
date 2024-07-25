import 'package:desktop/src/views/HomePage/components/DashboardCard.dart';
import 'package:desktop/src/views/HomePage/components/EmptyDashboardCard.dart';
import 'package:desktop/src/models/ApiModel.dart';
import 'package:desktop/src/models/DashboardModel.dart';
import 'package:desktop/src/services/DashboardService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardRow extends StatelessWidget {
  final List<Dashboard> dashboardDetails;

  DashboardRow({required this.dashboardDetails});

  // Method to change window and create a new dahsboard
  void addDashboardAndChangePage(BuildContext context) {
    List<Api> apis = [];

    Future<Dashboard> dashboard = DashboardService().addDashboard(Dashboard(
      userId: '',
      title: 'DASHBOARD',
      apis: [],
    ));

    dashboard.then((retrievedDashboard) => {
          context.go('/dashboard/${retrievedDashboard.dashboardId}'),
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          if (dashboardDetails.isEmpty) EmptyDashboardCard(),
          ...dashboardDetails
              .map((dashboard) => DashboardCard(
                    dashboard: dashboard,
                  ))
              .toList(),
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: IconButton(
              icon: const Icon(
                Icons.add,
                size: 50.0,
              ),
              onPressed: () => {addDashboardAndChangePage(context)},
            ),
          ),
        ],
      ),
    );
  }
}
