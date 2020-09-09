import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery/constants.dart';
import 'package:gallery/models/user.dart';
import 'package:gallery/services/auth.dart';
import 'package:gallery/utils/log.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class UserService {
  static Future<String> authenticateUser(
      String username, FirebaseUser user) async {
    return await UserService.authenticate(username, '\$${user.uid}\$');
  }

  static Future<String> authenticate(String username, String password) async {
    final response = await http.post(
      '${Constants.urlApi}/authenticate',
      headers: await AuthService.getHeaders(false),
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

  static Future<bool> register(User user) async {
    final response = await http.post(
      '${Constants.urlApi}/register',
      headers: await AuthService.getHeaders(false),
      body: user.toMap(),
    );

    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('### 008: $jsonData');

      return true;
    } else {
      printError('register', jsonData);
      throw Exception('Failed to register user');
    }
  }

  static Future<String> getBoxItemValue(String key) async {
    var box = await Hive.openBox<String>('user');
    // var box = Hive.box<String>('user');

    var value = box.get(key);
    return value;
  }

  static Future<Null> setBoxItemValue(String key, String value) async {
    var box = await Hive.openBox<String>('user');
    // var box = Hive.box<String>('user');

    if (value != null) {
      await box.put(key, value);
    } else {
      await box.delete(key);
    }
  }
}
