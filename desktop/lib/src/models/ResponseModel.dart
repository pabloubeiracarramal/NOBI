import 'dart:convert';

class Response {
  final int responseId;
  final Map<String, dynamic> data; // Changed type to Map<String, dynamic>
  List<dynamic>? kpiIds;

  Response({
    required this.responseId,
    required this.data,
    this.kpiIds,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
        responseId: json['responseId'],
        data: json['data'] as Map<String, dynamic>,
        kpiIds: json['kpis']);
  }

  Map<String, dynamic> toJson() {
    return {
      'responseId': responseId,
      'data': data,
      'kpis': kpiIds,
    };
  }

  static Response parseJson(String jsonString) {
    final jsonResponse = jsonDecode(jsonString);
    return Response.fromJson(jsonResponse);
  }
}
