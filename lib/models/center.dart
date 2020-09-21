import 'dart:convert';

import 'package:gallery/models/district.dart';
import 'package:gallery/models/province.dart';

class Center {
  String address;
  String centerName;
  String description;
  District district;
  String id;
  int priority;
  Province province;

  Center({
    this.address,
    this.centerName,
    this.description,
    this.district,
    this.id,
    this.priority,
    this.province,
  });

  Center copyWith({
    String address,
    String centerName,
    String description,
    District district,
    String id,
    int priority,
    Province province,
  }) {
    return Center(
      address: address ?? this.address,
      centerName: centerName ?? this.centerName,
      description: description ?? this.description,
      district: district ?? this.district,
      id: id ?? this.id,
      priority: priority ?? this.priority,
      province: province ?? this.province,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'address': address,
      'centerName': centerName,
      'description': description,
      'district': district?.toMap(),
      'id': id,
      'priority': priority,
      'province': province?.toMap(),
    };
    return map;
  }

  factory Center.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Center(
      address: map['address'] as String,
      centerName: map['centerName'] as String,
      description: map['description'] as String,
      district: District.fromMap(map['district'] as Map<String, dynamic>),
      id: map['id'] as String,
      priority: map['priority'] as int,
      province: Province.fromMap(map['province'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Center.fromJson(String source) =>
      Center.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Center(address: $address, centerName: $centerName, description: $description, district: $district, id: $id, priority: $priority, province: $province)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Center &&
        o.address == address &&
        o.centerName == centerName &&
        o.description == description &&
        o.district == district &&
        o.id == id &&
        o.priority == priority &&
        o.province == province;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        centerName.hashCode ^
        description.hashCode ^
        district.hashCode ^
        id.hashCode ^
        priority.hashCode ^
        province.hashCode;
  }
}
