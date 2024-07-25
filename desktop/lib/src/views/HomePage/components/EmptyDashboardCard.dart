import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmptyDashboardCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: Card(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('No dashboards available.')],
          ),
        ),
      ),
    );
  }
}
