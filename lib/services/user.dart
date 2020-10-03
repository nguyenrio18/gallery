import 'dart:async';

import 'package:gallery/models/user.dart';
import 'package:gallery/utils/api_exception.dart';
import 'package:gallery/utils/json.dart';
import 'package:gallery/utils/graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';

class UserService {
  static const String hiveUserKeyId = 'id';
  static const String hiveUserKeyUsername = 'username';
  static const String hiveUserKeyEmail = 'email';
  static const String hiveUserKeyMemberType = 'memberType';
  static const String hiveUserKeyFullName = 'fullName';
  static const String hiveUserKeyPhoneNumber = 'phoneNumber';

  static const String hiveUserKeyToken = 'token';
  static const String hiveUserKeyLoggedIn = 'loggedin';

  static Future<String> authenticate(String username, String password) async {
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
            }
          }
        }
      '''),
      variables: variables,
    );

    var client = await GraphQLUtil.getGraphQLClient(false);
    var queryResult = await client.mutate(mutate);

    if (!queryResult.hasException) {
      var token = queryResult.data['login']['jwt'] as String;
      await UserService.setBoxItemValue(UserService.hiveUserKeyToken, token);
      GraphQLUtil.setupTokenExpiration();

      return queryResult.data['login']['user']['id'] as String;
    } else {
      throw ApiException.fromQueryResult(queryResult);
    }
  }

  static Future<String> register(User user) async {
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
            }
          }
        }
      '''),
      variables: variables,
    );

    var client = await GraphQLUtil.getGraphQLClient(false);
    var queryResult = await client.mutate(mutate);

    if (!queryResult.hasException) {
      var token = queryResult.data['register']['jwt'] as String;
      await UserService.setBoxItemValue(UserService.hiveUserKeyToken, token);
      GraphQLUtil.setupTokenExpiration();

      return queryResult.data['register']['user']['id'] as String;
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
                id
                username
                email
                phoneNumber
                fullName
                memberType
              }
            }
          }
        '''),
        variables: variablesUpdateUser,
      );

      var graphqlClient = await GraphQLUtil.getGraphQLClient(true);
      var queryResult = await graphqlClient.mutate(mutateUpdateUser);

      if (!queryResult.hasException) {
        await setHiveBoxUser(queryResult, 'updateUser');

        return true;
      } else {
        throw ApiException.fromQueryResult(queryResult);
      }
    }

    return false;
  }

  static Future<void> setHiveBoxUser(
      QueryResult queryResult, String mutationName) async {
    var parent = mutationName != null
        ? queryResult.data[mutationName]['user'] as Map<String, dynamic>
        : queryResult.data['user'] as Map<String, dynamic>;

    var id = parent['id'] as String;
    await UserService.setBoxItemValue(UserService.hiveUserKeyId, id);
    var username = parent['username'] as String;
    await UserService.setBoxItemValue(
        UserService.hiveUserKeyUsername, username);
    var email = parent['email'] as String;
    await UserService.setBoxItemValue(UserService.hiveUserKeyEmail, email);
    var phoneNumber = parent['phoneNumber'] as String;
    await UserService.setBoxItemValue(
        UserService.hiveUserKeyPhoneNumber, phoneNumber);
    var fullName = parent['fullName'] as String;
    await UserService.setBoxItemValue(
        UserService.hiveUserKeyFullName, fullName);
    var memberType = parent['memberType'] as int;
    await UserService.setBoxItemValue(
        UserService.hiveUserKeyMemberType, memberType);
  }

  static Future<User> getUserById(String id) async {
    var variables = {
      'id': id,
    };
    var query = QueryOptions(
      documentNode: gql(r'''
        query User($id: ID!) {
          user(id: $id) {
            id
            username
            email
            phoneNumber
            memberType
            fullName
          }
        }
      '''),
      variables: variables,
    );

    var client = await GraphQLUtil.getGraphQLClient(true);
    var queryResult = await client.query(query);

    if (!queryResult.hasException) {
      await setHiveBoxUser(queryResult, null);

      var user = User.fromMap(queryResult.data['user'] as Map<String, dynamic>);
      return user;
    } else {
      throw ApiException.fromQueryResult(queryResult);
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
