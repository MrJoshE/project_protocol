import 'dart:async';

import 'package:config/enet_request.dart';

Future main(List<String> args) async {
  final request = EnetRequest(
    path: '/',
    applicationHeaders: {},
  );
  final rawRequest = request.convertIntoRawRequest();

  print(rawRequest);

  print(EnetRequest.fromBuffer(rawRequest));
}
