import 'package:gallery/constants.dart';
import 'package:gallery/services/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLUtil {
  static const enableWebsockets = false;

  static GraphQLClient _graphQLClientHttpLink;
  static GraphQLClient _graphQLClientAuthLink;
  static DateTime _tokenExpiration;

  static DateTime setupTokenExpiration() {
    _tokenExpiration = DateTime.now()
        .add(const Duration(days: 1))
        .add(const Duration(hours: -1));
    return _tokenExpiration;
  }

  static Future<GraphQLClient> getGraphQLClient(bool useAuthLink) async {
    if (!useAuthLink) {
      if (GraphQLUtil._graphQLClientHttpLink != null) {
        return GraphQLUtil._graphQLClientHttpLink;
      }

      var httpLink = HttpLink(uri: Constants.urlApi);
      GraphQLUtil._graphQLClientHttpLink = GraphQLClient(
        link: httpLink,
        cache: InMemoryCache(),
      );

      return GraphQLUtil._graphQLClientHttpLink;
    } else {
      if (GraphQLUtil._graphQLClientAuthLink != null &&
          DateTime.now().isBefore(GraphQLUtil._tokenExpiration)) {
        return GraphQLUtil._graphQLClientAuthLink;
      }

      var httpLink = HttpLink(uri: Constants.urlApi);
      var token =
          await UserService.getBoxItemValue(UserService.hiveUserKeyToken)
              as String;
      var authLink = AuthLink(
        getToken: () async => 'Bearer ' + token,
      );
      var link = authLink.concat(httpLink);
      GraphQLUtil._graphQLClientAuthLink = GraphQLClient(
        link: link,
        cache: InMemoryCache(),
      );

      return GraphQLUtil._graphQLClientAuthLink;
    }
  }
}
