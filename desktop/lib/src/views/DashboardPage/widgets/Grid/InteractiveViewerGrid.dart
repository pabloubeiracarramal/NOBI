import 'package:desktop/src/providers/shared_providers.dart';
import 'package:desktop/src/views/DashboardPage/widgets/Grid/DraggableGridItem.dart';
import 'package:desktop/src/views/DashboardPage/widgets/Grid/GridBackgroundBuilder.dart';
import 'package:desktop/src/views/DashboardPage/widgets/Grid/GridItem.dart';
import 'package:desktop/src/views/DashboardPage/widgets/Grid/GridWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InteractiveViewerGrid extends ConsumerWidget {
  final TransformationController controller;
  final Rect viewport;

  const InteractiveViewerGrid({
    Key? key,
    required this.controller,
    required this.viewport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridItems = ref.watch(gridItemsProvider);
    return Stack(
      children: [
        GridBackgroundBuilder(
          cellWidth: 50,
          cellHeight: 50,
          viewport: viewport,
        ),
        ...gridItems.map(
          (item) => DraggableGridItem(
            left: item.columnStart * 50.0,
            top: item.rowStart * 50.0,
            item: item,
          ),
        ),
      ],
    );
  }
}
