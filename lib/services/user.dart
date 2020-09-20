import 'dart:async';
import 'dart:convert';

import 'package:gallery/constants.dart';
import 'package:gallery/models/user.dart';
import 'package:gallery/services/auth.dart';
import 'package:gallery/utils/api_exception.dart';
import 'package:gallery/utils/json.dart';
import 'package:gallery/utils/log.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class UserService {
  static const String hiveUserKeyToken = 'token';
  static const String hiveUserKeyUserType = 'usertype';
  static const String hiveUserKeyLoggedIn = 'loggedin';

  static const String hiveUserKeyId = 'id';
  static const String hiveUserKeyEmail = 'email';
  static const String hiveUserKeyName = 'name';
  static const String hiveUserKeyPhoneNumber = 'phoneNumber';

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
      await UserService.setBoxItemValue(UserService.hiveUserKeyToken, token);

      return token;
    } else {
      throw ApiException.fromJson(response.body);
    }
  }

  static Future<bool> register(User user) async {
    var userRemovedNull = JsonUtil.removeFieldWithNullValue(user.toMap());

    final response = await http.post(
      '${Constants.urlApi}/register',
      headers: await AuthService.getHeaders(false),
      body: jsonEncode(userRemovedNull),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      printError('register', jsonData);
      throw ApiException.fromJson(response.body);
    }
  }

  static Future<User> getAccount() async {
    final response = await http.get(
      '${Constants.urlApi}/account',
      headers: await AuthService.getHeaders(true),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var account = User.fromJson(response.body);

      await UserService.setBoxItemValue(UserService.hiveUserKeyId, account.id);
      await UserService.setBoxItemValue(
          UserService.hiveUserKeyName, account.firstName);
      await UserService.setBoxItemValue(
          UserService.hiveUserKeyEmail, account.email);
      await UserService.setBoxItemValue(
          UserService.hiveUserKeyPhoneNumber, account.lastName);

      var isMentor = account.authorities.contains(User.roleMentor);
      var isMentee = account.authorities.contains(User.roleMentee);
      if (isMentor) {
        await UserService.setBoxItemValue(
            UserService.hiveUserKeyUserType, User.roleMentor);
      }
      if (isMentee) {
        await UserService.setBoxItemValue(
            UserService.hiveUserKeyUserType, User.roleMentee);
      }

      return account;
    } else {
      throw ApiException.fromJson(response.body);
    }
  }

  static Future<dynamic> getBoxItemValue(String key) async {
    var box = await Hive.openBox<dynamic>('user');
    // var box = Hive.box<String>('user');

    dynamic value = box.get(key);
    return value;
  }

  static Future<Null> setBoxItemValue(String key, dynamic value) async {
    var box = await Hive.openBox<dynamic>('user');
    // var box = Hive.box<String>('user');

    if (value != null) {
      await box.put(key, value);
    } else {
      await box.delete(key);
    }
  }
}
