import 'package:desktop/src/models/ResponseModel.dart';

class Kpi {
  int? id;
  String? title;
  String? position;
  String? entry;
  int? endpointId;
  int? dashboardId;
  List<Response>? responses;
  String? type;

  Kpi({
    this.id,
    required this.title,
    required this.position,
    required this.entry,
    required this.endpointId,
    required this.dashboardId,
    this.responses,
    required this.type,
  });

  factory Kpi.fromJson(Map<String, dynamic> json) {
    var list = json['responses'] as List;
    List<Response> responsesList =
        list.map((i) => Response.fromJson(i)).toList();

    return Kpi(
      id: json['kpiId'],
      title: json['title'],
      position: json['position'],
      entry: json['entry'],
      endpointId: json['endpointId'],
      dashboardId: json['dashboardId'],
      responses: responsesList,
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kpiId': id,
      'title': title,
      'position': position,
      'entry': entry,
      'endpointId': endpointId,
      'dashboardId': dashboardId,
      'responses': responses?.map((response) => response.toJson()).toList(),
      'type': type,
    };
  }

  Kpi copyWith({
    int? id,
    String? title,
    String? position,
    String? entry,
    int? endpointId,
    int? dashboardId,
    List<Response>? responses,
    String? type,
    bool resetId = false,
    bool resetTitle = false,
    bool resetPosition = false,
    bool resetEntry = false,
    bool resetEndpointId = false,
    bool resetDashboardId = false,
    bool resetResponses = false,
    bool resetType = false,
  }) {
    return Kpi(
      id: resetId ? null : id ?? this.id,
      title: resetTitle ? null : title ?? this.title,
      position: resetPosition ? null : position ?? this.position,
      entry: resetEntry ? null : entry ?? this.entry,
      endpointId: resetEndpointId ? null : endpointId ?? this.endpointId,
      dashboardId: resetDashboardId ? null : dashboardId ?? this.dashboardId,
      responses: resetResponses ? null : responses ?? this.responses,
      type: resetType ? null : type ?? this.type,
    );
  }

  @override
  String toString() {
    return 'Kpi{id: $id, title: $title, position: $position, entry: $entry, endpointId: $endpointId, dashboardId: $dashboardId, responses: $responses, type: $type}';
  }
}
