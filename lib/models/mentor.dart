import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:gallery/models/center.dart';
import 'package:gallery/models/district.dart';
import 'package:gallery/models/mentor_location.dart';
import 'package:gallery/models/province.dart';
import 'package:gallery/models/user.dart';
import 'package:gallery/models/model_plh.dart';

class Mentor {
  String id;
  String fullName;
  String email;
  String phoneNumber;
  DateTime birthdate;
  DateTime startDate;
  double rate;
  String description;
  // photo: ;
  User user;
  Province province;
  District district;
  List<Center> centers;
  List<MentorLocation> mentorLocations;
  Mentor({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.birthdate,
    this.startDate,
    this.rate,
    this.description,
    this.user,
    this.province,
    this.district,
    this.centers,
    this.mentorLocations,
  });

  Mentor copyWith({
    String id,
    String fullName,
    String email,
    String phoneNumber,
    DateTime birthdate,
    DateTime startDate,
    double rate,
    String description,
    User user,
    Province province,
    District district,
    List<Center> centers,
    List<MentorLocation> mentorLocations,
  }) {
    return Mentor(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthdate: birthdate ?? this.birthdate,
      startDate: startDate ?? this.startDate,
      rate: rate ?? this.rate,
      description: description ?? this.description,
      user: user ?? this.user,
      province: province ?? this.province,
      district: district ?? this.district,
      centers: centers ?? this.centers,
      mentorLocations: mentorLocations ?? this.mentorLocations,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthdate': birthdate != null ? birthdate.toIso8601String() : null,
      'startDate': startDate != null ? startDate.toIso8601String() : null,
      'rate': rate,
      'description': description,
      'user': user?.toMap(),
      'province': province?.toMap(),
      'district': district?.toMap(),
      'centers': centers?.map((x) => x?.toMap())?.toList(),
      'mentorLocations': mentorLocations?.map((x) => x?.toMap())?.toList(),
    };
    return map;
  }

  factory Mentor.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Mentor(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      birthdate: DateTime.tryParse(map['birthdate'] as String),
      startDate: DateTime.tryParse(map['startDate'] as String),
      rate: map['rate'] as double,
      description: map['description'] as String,
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      province: Province.fromMap(map['province'] as Map<String, dynamic>),
      district: District.fromMap(map['district'] as Map<String, dynamic>),
      centers: List<Center>.from(map['centers']
              ?.map((dynamic x) => ModelPlh.fromMap(x as Map<String, dynamic>))
          as List<ModelPlh>),
      mentorLocations: List<MentorLocation>.from(map['mentorLocations']
              ?.map((dynamic x) => ModelPlh.fromMap(x as Map<String, dynamic>))
          as List<ModelPlh>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Mentor.fromJson(String source) =>
      Mentor.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<Mentor> fromJsonList(Uint8List source) {
    final jsonList = json.decode(utf8.decode(source)) as List;

    var result = jsonList.map((dynamic json) {
      return Mentor.fromMap(json as Map<String, dynamic>);
    }).toList();

    return result;
  }

  @override
  String toString() {
    return 'Mentor(id: $id, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, birthdate: $birthdate, startDate: $startDate, rate: $rate, description: $description, user: $user, province: $province, district: $district, centers: $centers, mentorLocations: $mentorLocations)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is Mentor &&
        o.id == id &&
        o.fullName == fullName &&
        o.email == email &&
        o.phoneNumber == phoneNumber &&
        o.birthdate == birthdate &&
        o.startDate == startDate &&
        o.rate == rate &&
        o.description == description &&
        o.user == user &&
        o.province == province &&
        o.district == district &&
        listEquals(o.centers, centers) &&
        listEquals(o.mentorLocations, mentorLocations);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        birthdate.hashCode ^
        startDate.hashCode ^
        rate.hashCode ^
        description.hashCode ^
        user.hashCode ^
        province.hashCode ^
        district.hashCode ^
        centers.hashCode ^
        mentorLocations.hashCode;
  }

  void cleanServerMessage() {}
}
