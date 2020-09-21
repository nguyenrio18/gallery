import 'dart:async';
import 'dart:convert';

import 'package:gallery/constants.dart';
import 'package:gallery/services/auth.dart';
import 'package:gallery/models/mentor.dart';
import 'package:http/http.dart' as http;
import 'package:gallery/utils/api_exception.dart';

class MentorService {
  static Future<List<Mentor>> getMentors() async {
    final response = await http.get(
      '${Constants.urlApi}/mentors',
      headers: await AuthService.getHeaders(true),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Mentor.fromJsonList(response.bodyBytes);
    } else {
      throw ApiException.fromJson(response.body);
    }
  }

  static Future<Mentor> getMentorByUserId(String userId) async {
    final response = await http.get(
      '${Constants.urlApi}/mentors/by-user-id/$userId',
      headers: await AuthService.getHeaders(true),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Mentor.fromJson(response.body);
    } else {
      throw ApiException.fromJson(response.body);
    }
  }

  static Future<Mentor> updateMentor(String title) async {
    final response = await http.put(
      'url',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
      }),
    );

    if (response.statusCode == 200) {
      var map = json.decode(response.body) as Map<String, dynamic>;
      return Mentor.fromMap(map);
    } else {
      throw Exception('Failed to update album.');
    }
  }

  static Future<Mentor> insertMentor(
      String title, int id, String imageUrl, int quantity) async {
    final response = await http.post(
      'url',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'id': id.toString(),
        'imageUrl': imageUrl,
        'quantity': quantity.toString()
      }),
    );
    if (response.statusCode == 201) {
      var map = json.decode(response.body) as Map<String, dynamic>;
      return Mentor.fromMap(map);
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<Mentor> deleteMentor(int id) async {
    final response = await http.delete(
      'url/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var map = json.decode(response.body) as Map<String, dynamic>;
      return Mentor.fromMap(map);
    } else {
      throw Exception('Failed to delete album.');
    }
  }
}
