class Endpoint {
  final int endpointId;
  String url;
  String method;
  int waitTime;
  String mode;

  Endpoint({
    required this.endpointId,
    required this.url,
    required this.method,
    required this.waitTime,
    required this.mode,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Endpoint &&
        other.endpointId == endpointId &&
        other.url == url &&
        other.method == method &&
        other.waitTime == waitTime &&
        other.mode == mode;
  }

  @override
  int get hashCode {
    return endpointId.hashCode ^
        url.hashCode ^
        method.hashCode ^
        waitTime.hashCode ^
        mode.hashCode;
  }

  factory Endpoint.fromJson(Map<String, dynamic> json) {
    return Endpoint(
      endpointId: json['endpointId'],
      url: json['url'],
      method: json['method'],
      waitTime: json['waitTime'],
      mode: json['mode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'endpointId': endpointId,
      'url': url,
      'method': method,
      'waitTime': waitTime,
      'mode': mode,
    };
  }

  @override
  String toString() {
    return 'Endpoint{endpointId: $endpointId, url: $url, method: $method, waitTime: $waitTime, mode: $mode}';
  }
}
