import 'package:desktop/src/models/KpiModel.dart';
import 'package:flutter/material.dart';

class GridItem {
  final String label;
  final int columnStart;
  final int rowStart;
  final int columnSpan;
  final int rowSpan;
  Widget child;
  final int id;
  late Kpi? kpi;

  GridItem({
    required this.label,
    required this.columnStart,
    required this.rowStart,
    required this.columnSpan,
    required this.rowSpan,
    required this.child,
    required this.id,
    this.kpi,
  });

  GridItem copyWith({
    String? label,
    int? columnStart,
    int? rowStart,
    int? columnSpan,
    int? rowSpan,
    Widget? child,
    int? id,
    Kpi? kpi,
  }) {
    return GridItem(
      label: label ?? this.label,
      columnStart: columnStart ?? this.columnStart,
      rowStart: rowStart ?? this.rowStart,
      columnSpan: columnSpan ?? this.columnSpan,
      rowSpan: rowSpan ?? this.rowSpan,
      child: child ?? this.child,
      id: id ?? this.id,
      kpi: kpi ?? this.kpi,
    );
  }
}
