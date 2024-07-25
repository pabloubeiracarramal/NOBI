import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusNotifier extends StateNotifier<String> {
  StatusNotifier() : super("Stopped");

  void updateStatus(String status) {
    state = status;
  }
}
