import 'dart:convert';

class ApiException implements Exception {
  final String message;
  final String name;

  ApiException({
    this.message,
    this.name,
  });

  ApiException copyWith({
    String message,
    String name,
  }) {
    return ApiException(
      message: message ?? this.message,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'message': message,
      'name': name,
    };
    return map;
  }

  factory ApiException.fromMap(Map<String, dynamic> map) {
    if (map == null || map['errors'] == null) return null;

    var firstError = map['errors'][0] as Map<String, dynamic>;
    if (firstError['message'] == 'Bad Request') {
      return ApiException(
        message: map['extensions']['exception']['data']['message'][0]
            ['messages'][0]['message'] as String,
        name: map['extensions']['exception']['data']['message'][0]['messages']
            [0]['id'] as String,
      );
    } else {
      return ApiException(
        message: map['extensions']['exception']['message'] as String,
        name: map['extensions']['exception']['name'] as String,
      );
    }
  }

  String toJson() => json.encode(toMap());

  factory ApiException.fromJson(String source) =>
      ApiException.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ApiException(message: $message, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ApiException && o.message == message && o.name == name;
  }

  @override
  int get hashCode => message.hashCode ^ name.hashCode;
}
