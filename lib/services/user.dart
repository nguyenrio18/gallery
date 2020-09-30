import 'dart:async';

import 'package:gallery/constants.dart';
import 'package:gallery/models/user.dart';
import 'package:gallery/services/auth.dart';
import 'package:gallery/utils/api_exception.dart';
import 'package:gallery/utils/json.dart';
import 'package:gallery/utils/graphql.dart';
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

  static Future<bool> authenticate(String username, String password) async {
    var variables = {
      'input': {
        'identifier': username,
        'password': password,
        'provider': 'local'
      }
    };
    var mutate = MutationOptions(
      documentNode: gql(r'''
        mutation Login($input: UsersPermissionsLoginInput!) {
          login(input: $input) {
            jwt
            user {
              id
              username
              email
              fullName
              phoneNumber
              userType
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

    var client = await GraphQLUtil.getGraphQLClient(false);
    var queryResult = await client.mutate(mutate);

    String id;
    if (!queryResult.hasException) {
      var token = queryResult.data['login']['jwt'] as String;
      await UserService.setBoxItemValue(UserService.hiveUserKeyToken, token);

      GraphQLUtil.setupTokenExpiration();

      id = queryResult.data['login']['user']['id'] as String;
      await UserService.setBoxItemValue(UserService.hiveUserKeyId, id);
      var username = queryResult.data['login']['user']['username'] as String;
      await UserService.setBoxItemValue(
          UserService.hiveUserKeyUsername, username);
      var email = queryResult.data['login']['user']['email'] as String;
      await UserService.setBoxItemValue(UserService.hiveUserKeyEmail, email);

      return true;
    } else {
      throw ApiException.fromQueryResult(queryResult);
    }
  }

  static Future<bool> register(User user) async {
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

    var client = await GraphQLUtil.getGraphQLClient(false);
    var queryResult = await client.mutate(mutate);

    String id;
    if (!queryResult.hasException) {
      var token = queryResult.data['register']['jwt'] as String;
      await UserService.setBoxItemValue(UserService.hiveUserKeyToken, token);

      GraphQLUtil.setupTokenExpiration();

      id = queryResult.data['register']['user']['id'] as String;
      await UserService.setBoxItemValue(UserService.hiveUserKeyId, id);
      var username = queryResult.data['register']['user']['username'] as String;
      await UserService.setBoxItemValue(
          UserService.hiveUserKeyUsername, username);
      var email = queryResult.data['register']['user']['email'] as String;
      await UserService.setBoxItemValue(UserService.hiveUserKeyEmail, email);

      return updateUser(id, user);
    } else {
      throw ApiException.fromQueryResult(queryResult);
    }
  }

  static Future<bool> updateUser(String id, User user) async {
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

      var graphqlClient = await GraphQLUtil.getGraphQLClient(true);
      var queryResult = await graphqlClient.mutate(mutateUpdateUser);

      if (!queryResult.hasException) {
        return true;
      } else {
        throw ApiException.fromQueryResult(queryResult);
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
