import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery/constants.dart';
import 'package:gallery/services/user.dart';
import 'package:hive/hive.dart';

class AuthService {
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

      await saveToken(token);
    } catch (e) {
      try {
        final token =
            await UserService.authenticate(email, '\$${Constants.words}\$');

        await saveToken(token);
      } catch (e2) {
        print('authenticate: $e2');
        throw e;
      }
    }
  }

  static Future saveToken(String token) async {
    var box = await Hive.openBox<String>('user');
    // var box = Hive.box<String>('user');
    await box.put('token', token);
  }

  static Future<void> handleSignOut() async {
    try {
      final auth = FirebaseAuth.instance;

      await auth.signOut();

      var box = await Hive.openBox<String>('user');
      // var box = Hive.box<String>('user');
      await box.delete('token');
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
