import 'package:desktop/src/models/ApiModel.dart';

import 'dart:convert';

import 'package:flutter/foundation.dart';

class Dashboard {
  int? dashboardId;
  String userId;
  String title;
  final List<Api> apis;

  Dashboard({
    this.dashboardId,
    required this.userId,
    required this.title,
    required this.apis,
  });

  Dashboard copyWith({
    String? title,
    List<Api>? apis,
  }) {
    return Dashboard(
      dashboardId: this.dashboardId, // dashboardId is not changed
      userId: this.userId, // userId is not changed
      title: title ?? this.title, // Allow title to be changed
      apis: apis ?? this.apis, // Allow apis list to be changed
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Dashboard &&
        other.dashboardId == dashboardId &&
        other.userId == userId &&
        other.title == title &&
        listEquals(other.apis, apis);
  }

  @override
  int get hashCode =>
      dashboardId.hashCode ^ userId.hashCode ^ title.hashCode ^ apis.hashCode;

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    var list = json['apis'] as List;
    List<Api> apisList = list.map((i) => Api.fromJson(i)).toList();

    return Dashboard(
      dashboardId: json['dashboardId'],
      userId: json['userId'],
      title: json['title'],
      apis: apisList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dashboardId': dashboardId,
      'userId': userId,
      'title': title,
      'apis': apis.map((api) => api.toJson()).toList(),
    };
  }

  static Dashboard parseJson(String jsonString) {
    final jsonResponse = jsonDecode(jsonString);
    return Dashboard.fromJson(jsonResponse);
  }
}
