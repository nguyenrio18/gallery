import 'dart:convert';

import 'package:gallery/models/district.dart';
import 'package:gallery/models/province.dart';

class MentorLocation {
  String description;
  District district;
  String id;
  double latitude;
  double longitude;
  String mentorLocationName;
  Province province;

  MentorLocation({
    this.description,
    this.district,
    this.id,
    this.latitude,
    this.longitude,
    this.mentorLocationName,
    this.province,
  });

  MentorLocation copyWith({
    String description,
    District district,
    String id,
    double latitude,
    double longitude,
    String mentorLocationName,
    Province province,
  }) {
    return MentorLocation(
      description: description ?? this.description,
      district: district ?? this.district,
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      mentorLocationName: mentorLocationName ?? this.mentorLocationName,
      province: province ?? this.province,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'description': description,
      'district': district?.toMap(),
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'mentorLocationName': mentorLocationName,
      'province': province?.toMap(),
    };
    return map;
  }

  factory MentorLocation.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MentorLocation(
      description: map['description'] as String,
      district: District.fromMap(map['district'] as Map<String, dynamic>),
      id: map['id'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      mentorLocationName: map['mentorLocationName'] as String,
      province: Province.fromMap(map['province'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory MentorLocation.fromJson(String source) =>
      MentorLocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MentorLocation(description: $description, district: $district, id: $id, latitude: $latitude, longitude: $longitude, mentorLocationName: $mentorLocationName, province: $province)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MentorLocation &&
        o.description == description &&
        o.district == district &&
        o.id == id &&
        o.latitude == latitude &&
        o.longitude == longitude &&
        o.mentorLocationName == mentorLocationName &&
        o.province == province;
  }

  @override
  int get hashCode {
    return description.hashCode ^
        district.hashCode ^
        id.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        mentorLocationName.hashCode ^
        province.hashCode;
  }
}
