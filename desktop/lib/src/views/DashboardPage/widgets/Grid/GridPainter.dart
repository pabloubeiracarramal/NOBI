import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final double cellWidth;
  final double cellHeight;
  final Rect viewport;
  final Color gridColor;

  GridPainter({
    required this.cellWidth,
    required this.cellHeight,
    required this.viewport,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.25;

    final int firstRow = (viewport.top / cellHeight).floor();
    final int lastRow = (viewport.bottom / cellHeight).ceil();
    final int firstCol = (viewport.left / cellWidth).floor();
    final int lastCol = (viewport.right / cellWidth).ceil();

    for (int row = firstRow; row <= lastRow; row++) {
      double y = row * cellHeight;
      canvas.drawLine(
          Offset(viewport.left, y), Offset(viewport.right, y), paint);
    }

    for (int col = firstCol; col <= lastCol; col++) {
      double x = col * cellWidth;
      canvas.drawLine(
          Offset(x, viewport.top), Offset(x, viewport.bottom), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
