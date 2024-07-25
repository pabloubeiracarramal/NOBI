import 'package:flutter/foundation.dart';

import 'EndpointModel.dart';

class Api {
  final int id;
  String name;
  String baseUrl;
  String token;
  List<Endpoint> endpoints;

  Api({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.token,
    required this.endpoints,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Api &&
        other.id == id &&
        other.name == name &&
        other.baseUrl == baseUrl &&
        other.token == token &&
        listEquals(other.endpoints, endpoints);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        baseUrl.hashCode ^
        token.hashCode ^
        endpoints.hashCode;
  }

  factory Api.fromJson(Map<String, dynamic> json) {
    var list = json['endpoints'] as List;
    List<Endpoint> endpointList =
        list.map((i) => Endpoint.fromJson(i)).toList();

    return Api(
      id: json['id'],
      name: json['name'],
      baseUrl: json['baseUrl'],
      token: json['token'],
      endpoints: endpointList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'baseUrl': baseUrl,
      'token': token,
      'endpoints': endpoints.map((endpoint) => endpoint.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Api{id: $id, name: $name, baseUrl: $baseUrl, token: $token, endpoints: $endpoints}';
  }
}
