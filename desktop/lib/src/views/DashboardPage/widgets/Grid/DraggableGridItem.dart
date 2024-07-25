import 'dart:math';
import 'package:desktop/src/services/KpiService.dart';
import 'package:desktop/src/views/DashboardPage/widgets/Grid/GridItem.dart';
import 'package:desktop/src/providers/shared_providers.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DraggableGridItem extends ConsumerStatefulWidget {
  final GridItem item;
  final double left;
  final double top;

  DraggableGridItem({
    Key? key,
    required this.item,
    required this.left,
    required this.top,
  }) : super(key: key);

  @override
  _DraggableGridItemState createState() => _DraggableGridItemState();
}

class _DraggableGridItemState extends ConsumerState<DraggableGridItem>
    with SingleTickerProviderStateMixin {
  // Initial positions and sizes
  late int initialColumnStart;
  late int initialRowStart;
  late int initialColumnSpan;
  late int initialRowSpan;

  // Final positions and sizes
  late int finalColumnPos;
  late int finalRowPos;
  late int finalColumnSpan;
  late int finalRowSpan;

  // For showing the ghost
  bool showGhost = false;
  Offset ghostPosition = Offset(0, 0);
  Size ghostSize = Size(60, 60);

  // Offset from initial click position
  Offset clickOffset = Offset(0, 0);

  // Hover
  AnimationController? _animationController;
  Animation<double>? _opacity;
  Animation<double>? _scale;
  Animation<double>? _rotation;

  // Size and color transformations during drag
  bool isDragging = false;
  double itemScale = 1.0;
  Color itemColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _opacity =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);
    _scale = Tween<double>(begin: 0.1, end: 1.0).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));
    _rotation = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovering) {
    if (isHovering) {
      _animationController?.forward();
    } else {
      _animationController?.reverse();
    }
  }

  void deleteKpi() {
    ref.read(gridItemsProvider.notifier).deleteKpi(widget.item.id.toString());
  }

  // DRAG HANDLERS
  // =============

  void handleDragStart(BuildContext context, DragStartDetails details) {
    setState(() {
      initialColumnStart = widget.item.columnStart;
      initialRowStart = widget.item.rowStart;
      clickOffset = details.localPosition;
      showGhost = true;
      isDragging = true;
      itemScale = 1.0125;
      itemColor = Color.fromARGB(148, 247, 247, 247)!;
      ghostPosition = Offset(initialColumnStart * 50.0, initialRowStart * 50.0);
      ghostSize =
          Size(widget.item.columnSpan * 50.0, widget.item.rowSpan * 50.0);
    });
  }

  void handleDragUpdate(BuildContext context, DragUpdateDetails details) {
    final localPosition = details.localPosition - clickOffset;
    setState(() {
      finalColumnPos = initialColumnStart + (localPosition.dx / 50).floor();
      finalRowPos = initialRowStart + (localPosition.dy / 50).floor();
      ghostPosition = Offset(finalColumnPos * 50.0, finalRowPos * 50.0);
    });
  }

  void handleDragEnd(BuildContext context, DragEndDetails details) {
    ref
        .read(gridItemsProvider.notifier)
        .updateItemPosition('${widget.item.id}', finalColumnPos, finalRowPos);
    setState(() {
      showGhost = false;
      isDragging = false;
      itemScale = 1.0;
      itemColor = Colors.white;
    });
  }

  // RESIZE HANDLERS
  // ===============

  void handleResizeStart(BuildContext context, DragStartDetails details) {
    setState(() {
      initialColumnSpan = widget.item.columnSpan;
      initialRowSpan = widget.item.rowSpan;
      clickOffset = details.localPosition;
      showGhost = true;
      isDragging = true;
      itemScale = 0.9;
      itemColor = Colors.grey[300]!;
      ghostPosition =
          Offset(widget.item.columnStart * 50.0, widget.item.rowStart * 50.0);
      ghostSize = Size(initialColumnSpan * 50.0, initialRowSpan * 50.0);
    });
  }

  void handleResizeUpdate(BuildContext context, DragUpdateDetails details) {
    final localPosition = details.localPosition - clickOffset;
    setState(() {
      finalColumnSpan = initialColumnSpan + (localPosition.dx / 50).floor();
      finalRowSpan = initialRowSpan + (localPosition.dy / 50).floor();
      if (finalColumnSpan > 0 && finalRowSpan > 0) {
        ghostSize = Size(finalColumnSpan * 50.0, finalRowSpan * 50.0);
      }
    });
  }

  void handleResizeEnd(BuildContext context, DragEndDetails details) {
    if (finalColumnSpan > 0 && finalRowSpan > 0) {
      ref
          .read(gridItemsProvider.notifier)
          .updateItemSize('${widget.item.id}', finalColumnSpan, finalRowSpan);
    }
    setState(() {
      showGhost = false;
      isDragging = false;
      itemScale = 1.0;
      itemColor = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: widget.left,
          top: widget.top,
          child: GestureDetector(
            onPanStart: (details) => handleDragStart(context, details),
            onPanUpdate: (details) => handleDragUpdate(context, details),
            onPanEnd: (details) => handleDragEnd(context, details),
            child: AnimatedScale(
              scale: itemScale,
              duration: const Duration(milliseconds: 200),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.item.columnSpan * 50.0,
                height: widget.item.rowSpan * 50.0,
                decoration: BoxDecoration(
                  color: itemColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 216, 216, 216).withOpacity(1),
                      offset: Offset(0, 6),
                      blurRadius: 12,
                      spreadRadius: 0.1,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    ref
                        .read(detailContentProvider.notifier)
                        .setKpi(widget.item.kpi!);
                  },
                  onHover: _handleHover,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: widget.item.child,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: AnimatedBuilder(
                          animation: _animationController!,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotation!.value, // Rotation animation
                              child: Transform.scale(
                                scale: _scale!.value, // Scale animation
                                child: Opacity(
                                  opacity: _opacity!.value, // Opacity animation
                                  child: GestureDetector(
                                    onPanStart: (details) =>
                                        handleResizeStart(context, details),
                                    onPanUpdate: (details) =>
                                        handleResizeUpdate(context, details),
                                    onPanEnd: (details) =>
                                        handleResizeEnd(context, details),
                                    child: Transform.rotate(
                                      angle: pi / 2,
                                      child: Icon(Icons.arrow_outward,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: AnimatedBuilder(
                          animation: _animationController!,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotation!.value, // Rotation animation
                              child: Transform.scale(
                                scale: _scale!.value, // Scale animation
                                child: Opacity(
                                  opacity: _opacity!.value, // Opacity animation
                                  child: GestureDetector(
                                    onTap: () => deleteKpi(),
                                    child:
                                        Icon(Icons.close, color: Colors.grey),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showGhost)
          Positioned(
            left: ghostPosition.dx,
            top: ghostPosition.dy,
            child: Container(
              width: ghostSize.width,
              height: ghostSize.height,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 62, 185, 175).withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Color.fromARGB(255, 62, 185, 175).withOpacity(0.2),
                  )),
            ),
          ),
      ],
    );
  }
}
