import 'package:desktop/src/models/DashboardModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardCard extends StatefulWidget {
  final Dashboard dashboard;

  DashboardCard({required this.dashboard});

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  double _elevation = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/dashboard/${widget.dashboard.dashboardId}'),
      child: MouseRegion(
        onEnter: (_) => _increaseElevation(),
        onExit: (_) => _decreaseElevation(),
        child: Card(
          elevation: _elevation,
          color: Color.fromARGB(244, 255, 255, 255),
          surfaceTintColor: Color.fromARGB(255, 31, 104, 117),
          shadowColor: Color.fromARGB(172, 255, 255, 255),
          child: Container(
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.dashboard.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _increaseElevation() {
    setState(() {
      _elevation = 1.0;
    });
  }

  void _decreaseElevation() {
    setState(() {
      _elevation = 0.0;
    });
  }
}
