import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery/constants.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<String> authenticateUser(
      String username, FirebaseUser user) async {
    return await UserService.authenticate(username, '\$${user.uid}\$');
  }

  static Future<String> authenticate(String username, String password) async {
    final response = await http.post(
      '${Constants.urlApi}/authenticate',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      var token = jsonData['id_token'] as String;

      return token;
    } else {
      throw Exception('Failed to load token');
    }
  }
}
