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

  // factory Mentor.fromJson(Map<String, dynamic> json) {
  //   return Mentor(
  //     id: json['id'] as int,
  //     title: json['title'] as String,
  //     imageUrl:
  //         'https://www.diabete.qc.ca/wp-content/uploads/2014/08/Les-fruits.png',
  //     quantity: json['userId'] as int,
  //   );
  // }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'title': title,
  //     'imageUrl': imageUrl,
  //     'quantity': quantity,
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
