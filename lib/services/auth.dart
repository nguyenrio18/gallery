import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery/constants.dart';
import 'package:gallery/services/user.dart';

class AuthService {
  static Future<Map<String, String>> getToken() async {
    var token = UserService.getBoxItemValue('token');

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    return headers;
  }

  static Future<void> handleSignInEmail(String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;

      var result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = result.user;

      assert(user != null);
      assert(await user.getIdToken() != null);

      final currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);

      print('### USER: $user');

      final token = await UserService.authenticateUser(email, user);

      await UserService.setBoxItemValue('token', token);
    } catch (e) {
      if (e != null &&
          e.message != null &&
          // TODO: Check e.code for this case
          e.message.toString().contains('No implementation found')) {
        try {
          final token =
              await UserService.authenticate(email, '\$${Constants.words}\$');

          await UserService.setBoxItemValue('token', token);
        } catch (e2) {
          print('UserService.authenticate: $e2');
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

      await UserService.setBoxItemValue('token', null);
    } catch (e) {
      rethrow;
    }
  }

  Future<FirebaseUser> handleSignUp(String email, String password) async {
    final auth = FirebaseAuth.instance;

    var result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    return user;
  }
}
