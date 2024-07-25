import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:desktop/src/views/DashboardPage/widgets/ButtonsColumn.dart';
import 'package:desktop/src/views/DashboardPage/widgets/Detail.dart';
import 'package:desktop/src/views/DashboardPage/widgets/Grid/InteractiveViewerGrid.dart';
import 'package:desktop/src/providers/shared_providers.dart';
import 'package:desktop/src/views/DashboardPage/widgets/TopNavigationBar.dart';

class GridWidget extends ConsumerStatefulWidget {
  final int numColumns;
  final double screenWidth;
  final double screenHeight;

  const GridWidget({
    Key? key,
    required this.numColumns,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  ConsumerState<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends ConsumerState<GridWidget> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref
          .read(transformationControllerProvider.notifier)
          .setScreenSize(widget.screenWidth, widget.screenHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    const double viewerSize = 200000;

    final transformationController =
        ref.watch(transformationControllerProvider);

    final detailContent = ref.watch(detailContentProvider);

    Rect axisAlignedBoundingBox(Quad quad) {
      double xMin = quad.point0.x;
      double xMax = quad.point0.x;
      double yMin = quad.point0.y;
      double yMax = quad.point0.y;

      for (final Vector3 point in <Vector3>[
        quad.point1,
        quad.point2,
        quad.point3,
      ]) {
        if (point.x < xMin) {
          xMin = point.x;
        } else if (point.x > xMax) {
          xMax = point.x;
        }

        if (point.y < yMin) {
          yMin = point.y;
        } else if (point.y > yMax) {
          yMax = point.y;
        }
      }

      return Rect.fromLTRB(xMin, yMin, xMax, yMax);
    }

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            body: InteractiveViewer.builder(
              boundaryMargin: const EdgeInsets.all(50),
              minScale: 0.75,
              maxScale: 1.25,
              transformationController: transformationController,
              builder: (BuildContext context, Quad quad) {
                return Center(
                  child: SizedBox(
                    width: viewerSize,
                    height: viewerSize,
                    child: InteractiveViewerGrid(
                      controller: transformationController,
                      viewport: axisAlignedBoundingBox(quad),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: TopNavigationBar(),
          ),
          Positioned(
            top: 75,
            left: 10,
            child: ButtonsColumn(),
          ),
          if (detailContent != null)
            Positioned(
              top: 110,
              right: 10,
              child: Detail(
                onClose: () =>
                    ref.read(detailContentProvider.notifier).state = null,
              ),
            ),
        ],
      ),
    );
  }
}
