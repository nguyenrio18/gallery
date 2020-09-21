import 'dart:convert';
import 'dart:typed_data';

import 'package:gallery/models/province.dart';

class District {
  String id;
  String districtName;
  int priority;
  Province province;

  District({
    this.id,
    this.districtName,
    this.priority,
    this.province,
  });

  District copyWith({
    String id,
    String districtName,
    int priority,
    Province province,
  }) {
    return District(
      id: id ?? this.id,
      districtName: districtName ?? this.districtName,
      priority: priority ?? this.priority,
      province: province ?? this.province,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'districtName': districtName,
      'priority': priority,
      'province': province?.toMap(),
    };
    return map;
  }

  factory District.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return District(
      id: map['id'] as String,
      districtName: map['districtName'] as String,
      priority: map['priority'] as int,
      province: Province.fromMap(map['province'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory District.fromJson(String source) =>
      District.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<District> fromJsonList(Uint8List source) {
    final jsonList = json.decode(utf8.decode(source)) as List;

    var result = jsonList.map((dynamic json) {
      return District.fromMap(json as Map<String, dynamic>);
    }).toList();

    return result;
  }

  @override
  String toString() {
    return 'District(id: $id, districtName: $districtName, priority: $priority, province: $province)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is District &&
        o.id == id &&
        o.districtName == districtName &&
        o.priority == priority &&
        o.province == province;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        districtName.hashCode ^
        priority.hashCode ^
        province.hashCode;
  }
}
