import 'dart:async';

import 'package:client/enet_client.dart';
import 'package:config/enet_request.dart';

Future main(List<String> args) async {
  final request = EnetRequest(
    path: '/hello',
    applicationHeaders: {
      'appName': 'ProjectProtocol',
    },
  );

  final client = EnetClient(
    options: EnetRequestOptions(
      baseUrl: '127.0.0.1',
      port: 1820,
    ),
  );

  final response = await client.static(
    request.path,
    applicationHeaders: request.applicationHeaders,
  );

  print('Response: $response');
}
