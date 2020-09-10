import 'dart:convert';

class ApiException implements Exception {
  final String message;
  final String title;
  final int status;
  final String type;

  ApiException({
    this.message,
    this.title,
    this.status,
    this.type,
  });

  ApiException copyWith({
    String message,
    String title,
    int status,
    String type,
  }) {
    return ApiException(
      message: message ?? this.message,
      title: title ?? this.title,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'message': message,
      'title': title,
      'status': status,
      'type': type,
    };
    return map;
  }

  factory ApiException.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ApiException(
      message: map['message'] as String,
      title: map['title'] as String,
      status: map['status'] as int,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiException.fromJson(String source) =>
      ApiException.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ApiException(message: $message, title: $title, status: $status, type: $type)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ApiException &&
        o.message == message &&
        o.title == title &&
        o.status == status &&
        o.type == type;
  }

  @override
  int get hashCode {
    return message.hashCode ^ title.hashCode ^ status.hashCode ^ type.hashCode;
  }
}
