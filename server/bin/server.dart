import 'dart:io';
import 'dart:convert';

import 'package:config/config_impl.dart';

Future main() async {
  await startTCPServer();
}

//TCp

Future startTCPServer() async {
  final serverSocket = await ServerSocket.bind(InternetAddress.loopbackIPv4, Config.DEFAULT_PORT);
  print('Listening on port ${serverSocket.port}');

  await for (Socket socket in serverSocket) {
    socket.cast<List<int>>().transform(utf8.decoder).listen((data) {
      print('from ${socket.remoteAddress.address} data:' + data);
      socket.add(utf8.encode('hello client!'));
    });
  }
}
