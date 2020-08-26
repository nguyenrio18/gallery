import 'dart:async';
import 'dart:convert';

import 'package:gallery/constants.dart';
import 'package:gallery/services/auth.dart';
import 'package:gallery/models/mentor.dart';
import 'package:http/http.dart' as http;

class MentorService {
  static Future<List<Mentor>> fetchMentors() async {
    var headers = await AuthService.getToken();
    final response =
        await http.get('${Constants.urlApi}/mentors', headers: headers);
    if (response.statusCode == 200) {
      return decodeMentor(response.body);
    } else {
      throw Exception('Unable to fetch data from the REST API');
    }
  }

  static List<Mentor> decodeMentor(String responseBody) {
    final decodedList = jsonDecode(responseBody) as List;

    var result = decodedList.map((dynamic tagJson) {
      var mentor = Mentor.fromJson(tagJson);
      return mentor;
    }).toList();

    return result;
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
      return Mentor.fromJson(map);
    } else {
      throw Exception('Failed to update album.');
    }
  }

  static Future<Mentor> sendMentor(
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
      return Mentor.fromJson(map);
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<Mentor> deleteAlbum(int id) async {
    final response = await http.delete(
      'url/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var map = json.decode(response.body) as Map<String, dynamic>;
      return Mentor.fromJson(map);
    } else {
      throw Exception('Failed to delete album.');
    }
  }
}
