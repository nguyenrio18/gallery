import 'package:gallery/constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
  static const enableWebsockets = false;

  static final GraphQLConfiguration _instance =
      GraphQLConfiguration._internal();
  static GraphQLClient client;

  static Link setupGraphLink() {
    final httpLink = HttpLink(uri: Constants.urlApi);

    final authLink = AuthLink(
      // ignore: undefined_identifier
      getToken: () async => 'Bearer $YOUR_PERSONAL_ACCESS_TOKEN',
    );

    var link = authLink.concat(httpLink);

    if (GraphQLConfiguration.enableWebsockets) {
      final websocketLink = WebSocketLink(
        url: 'ws://localhost:8080/ws/graphql',
        config: const SocketClientConfig(
            autoReconnect: true, inactivityTimeout: Duration(seconds: 15)),
      );

      link = link.concat(websocketLink);
    }

    return link;
  }

  factory GraphQLConfiguration() {
    GraphQLConfiguration.client = GraphQLClient(
      cache: OptimisticCache(
        dataIdFromObject: typenameDataIdFromObject,
      ),
      link: setupGraphLink(),
    );

    // final clientNotifier = ValueNotifier<GraphQLClient>(GraphQLConfiguration.client);

    return _instance;
  }

  GraphQLConfiguration._internal();

  static GraphQLConfiguration get instance => _instance;
}
