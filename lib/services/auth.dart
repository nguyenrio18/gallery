import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:gallery/constants.dart';
import 'package:gallery/services/user.dart';
import 'package:gallery/models/user.dart';
import 'package:gallery/utils/log.dart';

class AuthService {
  static Future<Map<String, String>> getHeaders(bool hasAuthorization) async {
    var token = await UserService.getBoxItemValue(UserService.hiveUserKeyToken)
        as String;

    Map<String, String> headers;
    if (hasAuthorization) {
      headers = <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };
    } else {
      headers = <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      };
    }

    return headers;
  }

  static Future<String> handleSignInPassword(
      String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;

      var result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final fbuser = result.user;

      assert(fbuser != null);
      assert(await fbuser.getIdToken() != null);

      final currentUser = await auth.currentUser();
      assert(fbuser.uid == currentUser.uid);

      var userId = await UserService.authenticate(email, '\$8${fbuser.uid}6\$');
      await UserService.getUserById(userId);

      return currentUser.uid;
    } catch (e) {
      if (e is PlatformException &&
          e.message != null &&
          // TODO: Check e.code for this case
          e.message.toString().contains('No implementation found')) {
        try {
          printError('NoImplementationFound', e);
          var userId =
              await UserService.authenticate(email, '\$8${Constants.words}6\$');
          await UserService.getUserById(userId);
        } catch (e2) {
          printError('UserService.authenticate', e2);
          throw e;
        }
      }

      rethrow;
    }
  }

  static Future<void> handleSignOut() async {
    try {
      final auth = FirebaseAuth.instance;

      await auth.signOut();

      await UserService.setBoxItemValue(UserService.hiveUserKeyToken, null);
      await UserService.setBoxItemValue(
          UserService.hiveUserKeyMemberType, null);
      await UserService.setBoxItemValue(UserService.hiveUserKeyLoggedIn, null);
    } catch (e) {
      rethrow;
    }
  }

  static Future<FirebaseUser> handleSignUpPassword(User user) async {
    try {
      final auth = FirebaseAuth.instance;

      var result = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      final registedUser = result.user;

      printInfo('handleSignUpPassword', result);

      assert(registedUser != null);
      assert(await registedUser.getIdToken() != null);

      user.password = '\$8${registedUser.uid}6\$';
      var userId = await UserService.register(user);
      await UserService.updateUser(userId, user);

      return registedUser;
    } catch (e) {
      rethrow;
    }
  }
}
