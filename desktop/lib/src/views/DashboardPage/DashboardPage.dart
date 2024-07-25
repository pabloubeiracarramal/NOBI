import 'package:desktop/src/services/AuthService.dart';
import 'package:desktop/src/services/DataService.dart';
import 'package:desktop/src/views/DashboardPage/widgets/Graphs/GraphConfig.dart';
import 'package:desktop/src/views/DashboardPage/widgets/Grid/GridWidget.dart';
import 'package:desktop/src/providers/shared_providers.dart';
import 'package:desktop/src/views/DashboardPage/widgets/TopNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Ensure that DashboardPage extends ConsumerStatefulWidget
class DashboardPage extends ConsumerStatefulWidget {
  final String dashboardId;

  const DashboardPage({required this.dashboardId, Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

// Your state class now extends ConsumerState
class _DashboardPageState extends ConsumerState<DashboardPage> {
  int numColumns = 100;
  List<GraphConfig> graphConfigs = [];

  @override
  void initState() {
    super.initState();

    // Fetch the dashboard data and update the controller when the data is available
    // Fetch the dashboard data when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dashboardNotifier = ref.read(dashboardProvider.notifier);
      final gridItemsNotifier = ref.read(gridItemsProvider.notifier);
      try {
        await dashboardNotifier.loadDashboard(widget.dashboardId);
        print('Dashboard: ${widget.dashboardId}');
        await gridItemsNotifier.loadInitialItems(widget.dashboardId);
      } catch (e) {
        // Handle error if necessary
        print('Failed to load dashboard TEST: $e');
      }
    });

    DataService().connectToWebSocket();
  }

  @override
  void dispose() {
    DataService().disconnectFromWebSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardProvider);
    return Scaffold(
      body: dashboard == null
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GridWidget(
                          numColumns: numColumns,
                          screenHeight: MediaQuery.of(context).size.height,
                          screenWidth: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
