import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class TransformationNotifier extends StateNotifier<TransformationController> {
  static const double viewerSize = 200000;
  double storedScreenWidth = 0;
  double storedScreenHeight = 0;

  TransformationNotifier() : super(TransformationController());

  void setScreenSize(double screenWidth, double screenHeight) {
    storedScreenWidth = screenWidth;
    storedScreenHeight = screenHeight;
    state = TransformationController(
      Matrix4.translation(
        Vector3(
          (-viewerSize + storedScreenWidth) / 2,
          (-viewerSize + storedScreenHeight) / 2,
          0,
        ),
      ),
    );
  }

  void centerGrid() {
    state = TransformationController(
      Matrix4.translation(
        Vector3(
          (-viewerSize + storedScreenWidth) / 2,
          (-viewerSize + storedScreenHeight) / 2,
          0,
        ),
      ),
    );
  }
}
