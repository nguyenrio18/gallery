import 'dart:math';

import 'package:flutter/material.dart';

// @immutable
class Mentor {
  final String fullName;
  final String email;
  final String phoneNumber;
  final DateTime birthdate;
  final DateTime startDate;
  final double rate;
  final String description;
  // photo ImageBlob,

  Mentor(
      {this.fullName,
      this.email,
      this.phoneNumber,
      this.rate,
      this.description})
      : birthdate = DateTime.now(),
        startDate = DateTime.now().add(const Duration(minutes: 10));

  Mentor.random()
      : fullName = 'BMW ${1 + Random().nextInt(6)}',
        phoneNumber = '098765432${1 + Random().nextInt(6)}',
        email = 'bmw_${1 + Random().nextInt(6)}@test.png',
        rate = 200 + 20 * 1 / Random().nextInt(10),
        description = '',
        birthdate = DateTime.now(),
        startDate = DateTime.now().add(const Duration(minutes: 10));

  factory Mentor.fromJson(dynamic json) {
    return Mentor(
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      rate: json['rate'] as double,
      description: json['description'] as String,
      // TODO:
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'fullName': fullName,
  //     'phoneNumber': phoneNumber,
  //     'email': email,
  //     'rate': rate,
  //     'description': description,
  //     // TODO:
  //   };
  // }

  // @override
  // int get hashCode => id;

  // @override
  // bool operator ==(Object other) => other is Mentor && other.id == id;

  @override
  String toString() {
    return 'Mentor{fullName: $fullName, email: $email, birthdate: $birthdate}';
  }
}
