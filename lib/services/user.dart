import 'dart:async';
import 'dart:convert';

import 'package:gallery/constants.dart';
import 'package:gallery/models/user.dart';
import 'package:gallery/services/auth.dart';
import 'package:gallery/utils/api_exception.dart';
import 'package:gallery/utils/json.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class UserService {
  static const String hiveUserKeyId = 'id';
  static const String hiveUserKeyUsername = 'username';
  static const String hiveUserKeyEmail = 'email';
  static const String hiveUserKeyUserType = 'userType';
  static const String hiveUserKeyFullName = 'fullName';
  static const String hiveUserKeyPhoneNumber = 'phoneNumber';

  static const String hiveUserKeyToken = 'token';
  static const String hiveUserKeyLoggedIn = 'loggedin';

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
    var httpLink = HttpLink(uri: Constants.urlApi);
    // you can also use headers for authorization etc.
    var client = GraphQLClient(link: httpLink, cache: InMemoryCache());

    var variables = {
      'input': {
        'email': user.email,
        'password': user.password,
        'username': user.email
      }
    };
    var mutate = MutationOptions(
      documentNode: gql(r'''
        mutation Register($input: UsersPermissionsRegisterInput!) {
          register(input: $input) {
            jwt
            user {
              id
              username
              email
              confirmed
              blocked
              role {
                id
                name
                description
                type
              }
            }
          }
        }
      '''),
      variables: variables,
    );

    var result = await client.mutate(mutate);

    String id;
    if (!result.hasException) {
      var token = result.data['register']['jwt'] as String;
      await UserService.setBoxItemValue(UserService.hiveUserKeyToken, token);
      id = result.data['register']['user']['id'] as String;
      await UserService.setBoxItemValue(UserService.hiveUserKeyId, id);
      var username = result.data['register']['user']['username'] as String;
      await UserService.setBoxItemValue(
          UserService.hiveUserKeyUsername, username);
      var email = result.data['register']['user']['email'] as String;
      await UserService.setBoxItemValue(UserService.hiveUserKeyEmail, email);
    } else {
      var apiException = ApiException(
          message: result.exception.graphqlErrors.first.extensions.toString());
      throw apiException;
    }

    user.password = null;
    var userRemovedNull = JsonUtil.removeFieldWithNullValue(user.toMap());
    if (id != null && id.isNotEmpty) {
      var variablesUpdateUser = {
        'input': {
          'where': {'id': id},
          'data': userRemovedNull
        }
      };
      var mutateUpdateUser = MutationOptions(
        documentNode: gql(r'''
          mutation UpdateUser($input: updateUserInput!) {
            updateUser(input: $input) {
              user {
                email
                phoneNumber
              }
            }
          }
        '''),
        variables: variablesUpdateUser,
      );

      var token =
          await UserService.getBoxItemValue(UserService.hiveUserKeyToken)
              as String;
      final authLink = AuthLink(
        getToken: () async => 'Bearer ' + token,
      );

      final link2 = authLink.concat(httpLink);

      var client2 = GraphQLClient(link: link2, cache: InMemoryCache());

      var resultUpdateUser = await client2.mutate(mutateUpdateUser);

      if (!resultUpdateUser.hasException) {
        return true;
      } else {
        var apiException = ApiException(
            message:
                result.exception.graphqlErrors.first.extensions.toString());
        throw apiException;
      }
    }

    return false;
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
          UserService.hiveUserKeyFullName, account.fullName);
      await UserService.setBoxItemValue(
          UserService.hiveUserKeyEmail, account.email);
      await UserService.setBoxItemValue(
          UserService.hiveUserKeyPhoneNumber, account.phoneNumber);
      await UserService.setBoxItemValue(
          UserService.hiveUserKeyUserType, account.userType);

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
