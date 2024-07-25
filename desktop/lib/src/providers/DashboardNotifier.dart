import 'package:desktop/src/models/DashboardModel.dart';
import 'package:desktop/src/services/DashboardService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardNotifier extends StateNotifier<Dashboard?> {
  DashboardNotifier() : super(null);

  Future<void> loadDashboard(String dashboardId) async {
    // Implement the logic to load the dashboard
    // For example:
    state = await DashboardService().getDashboardById(dashboardId);
  }

  void updateDashboard(Dashboard dashboard) {
    // Implement the logic to update the dashboard
    state = dashboard;
    print('UPDATED DAHSBOARD');
  }
}
