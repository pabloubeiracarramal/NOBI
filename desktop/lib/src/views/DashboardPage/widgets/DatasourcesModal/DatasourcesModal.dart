import 'dart:ui';

import 'package:desktop/src/views/DashboardPage/widgets/DatasourcesModal/ApiConfiguration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desktop/src/models/DashboardModel.dart';
import 'package:desktop/src/models/ApiModel.dart';
import 'package:provider/provider.dart';
import '../../../../providers/shared_providers.dart';
// Import other necessary widgets and models

class DatasourcesModal extends ConsumerStatefulWidget {
  final Dashboard initialDashboard;
  const DatasourcesModal({Key? key, required this.initialDashboard})
      : super(key: key);

  @override
  _DatasourcesModalState createState() => _DatasourcesModalState();
}

class _DatasourcesModalState extends ConsumerState<DatasourcesModal> {
  late Dashboard _temporaryDashboard;

  @override
  void initState() {
    super.initState();
    _temporaryDashboard = widget.initialDashboard;
  }

  void _updateTemporaryState(Dashboard newState) {
    print('UPDATE TEMP DASHBORD');
    setState(() {
      _temporaryDashboard = newState;
    });
  }

  void _saveAndClose() {
    print('SAVE AND CLOSE');
    ref.read(dashboardProvider.notifier).updateDashboard(_temporaryDashboard);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: Dialog(
          backgroundColor: Color.fromARGB(255, 226, 255, 253).withOpacity(0.85),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.all(0),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () => _saveAndClose(),
                    icon: const Icon(Icons.close),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 100),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: ApiConfiguration(
                          dashboard: _temporaryDashboard,
                          onUpdateTemporaryState: _updateTemporaryState,
                        ),
                      )
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
