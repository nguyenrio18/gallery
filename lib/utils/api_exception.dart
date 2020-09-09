import 'dart:convert';

class ApiException implements Exception {
  final String message;
  final String title;
  final int status;
  ApiException({
    this.message,
    this.title,
    this.status,
  });

  ApiException copyWith({
    String message,
    String title,
    int status,
  }) {
    return ApiException(
      message: message ?? this.message,
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'message': message,
      'title': title,
      'status': status,
    };
    return map;
  }

  factory ApiException.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ApiException(
      message: map['message'] as String,
      title: map['title'] as String,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiException.fromJson(String source) =>
      ApiException.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ApiException(message: $message, title: $title, status: $status)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ApiException &&
        o.message == message &&
        o.title == title &&
        o.status == status;
  }

  @override
  int get hashCode => message.hashCode ^ title.hashCode ^ status.hashCode;
}
