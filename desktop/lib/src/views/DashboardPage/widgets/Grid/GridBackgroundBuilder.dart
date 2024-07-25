import 'package:desktop/src/views/DashboardPage/widgets/Grid/GridPainter.dart';
import 'package:flutter/material.dart';

class GridBackgroundBuilder extends StatelessWidget {
  final double cellWidth;
  final double cellHeight;
  final Rect viewport;

  const GridBackgroundBuilder({
    Key? key,
    required this.cellWidth,
    required this.cellHeight,
    required this.viewport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CustomPaint(
      size: Size(viewport.width, viewport.height),
      painter: GridPainter(
        cellWidth: cellWidth,
        cellHeight: cellHeight,
        viewport: viewport,
        gridColor: Color.fromARGB(255, 17, 51, 48).withOpacity(0.2),
      ),
    );
  }
}
