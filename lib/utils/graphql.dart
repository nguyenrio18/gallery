import 'package:gallery/constants.dart';
import 'package:gallery/services/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLUtil {
  static GraphQLClient _graphQLClientHttpLink;
  static GraphQLClient _graphQLClientAuthLink;
  static DateTime _tokenExpiration;

  static DateTime setupTokenExpiration() {
    _tokenExpiration = DateTime.now()
        .add(const Duration(days: 1))
        .add(const Duration(hours: -1));

    // Need to renew authLink for _graphQLClientAuthLink
    _graphQLClientAuthLink = null;

    return _tokenExpiration;
  }

  static Future<GraphQLClient> getGraphQLClient(bool useAuthLink) async {
    if (!useAuthLink) {
      if (_graphQLClientHttpLink != null) {
        return _graphQLClientHttpLink;
      }

      var httpLink = HttpLink(uri: Constants.urlApi);
      _graphQLClientHttpLink = GraphQLClient(
        link: httpLink,
        cache: InMemoryCache(),
      );

      return _graphQLClientHttpLink;
    } else {
      if (_graphQLClientAuthLink != null &&
          DateTime.now().isBefore(_tokenExpiration)) {
        return _graphQLClientAuthLink;
      }

      var httpLink = HttpLink(uri: Constants.urlApi);
      var token =
          await UserService.getBoxItemValue(UserService.hiveUserKeyToken)
              as String;
      var authLink = AuthLink(
        getToken: () async => 'Bearer $token',
      );
      var link = authLink.concat(httpLink);
      _graphQLClientAuthLink = GraphQLClient(
        link: link,
        cache: InMemoryCache(),
      );

      return _graphQLClientAuthLink;
    }
  }
}
