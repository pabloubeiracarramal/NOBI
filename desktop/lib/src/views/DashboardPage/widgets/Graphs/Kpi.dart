import 'package:desktop/src/models/KpiModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KpiWidget extends ConsumerWidget {
  final Kpi kpi;
  final dynamic value;

  const KpiWidget({required this.kpi, required this.value, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController(text: kpi.title);

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            isCollapsed: true,
            border: InputBorder.none,
          ),
          controller: titleController,
        ),
        SizedBox(height: 10),
        Text(value.toString()),
      ],
    );
  }
}
