import 'dart:convert';

import 'dart:typed_data';

class Province {
  String id;
  String provinceName;
  int priority;

  Province({
    this.id,
    this.provinceName,
    this.priority,
  });

  Province copyWith({
    String id,
    String provinceName,
    int priority,
  }) {
    return Province(
      id: id ?? this.id,
      provinceName: provinceName ?? this.provinceName,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'provinceName': provinceName,
      'priority': priority,
    };
    return map;
  }

  factory Province.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Province(
      id: map['id'] as String,
      provinceName: map['provinceName'] as String,
      priority: map['priority'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Province.fromJson(String source) =>
      Province.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<Province> fromJsonList(Uint8List source) {
    final jsonList = json.decode(utf8.decode(source)) as List;

    var result = jsonList.map((dynamic json) {
      return Province.fromMap(json as Map<String, dynamic>);
    }).toList();

    return result;
  }

  @override
  String toString() =>
      'Province(id: $id, provinceName: $provinceName, priority: $priority)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Province &&
        o.id == id &&
        o.provinceName == provinceName &&
        o.priority == priority;
  }

  @override
  int get hashCode => id.hashCode ^ provinceName.hashCode ^ priority.hashCode;
}
