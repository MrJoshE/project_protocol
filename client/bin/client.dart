import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'client_args.dart';

/// What the client needs to do:
///
/// 1. Create a socket connection with the sever.
/// 2. Make a request to the server
/// 3. Wait for the response
/// 4. Close the socket connection

Future main(List<String> args) async {
  await runZonedGuarded(() async {
    /// Parse the command line arguments
    final clientArgs = ClientArgs.fromArguments(args);

    await initializeTCPClient(clientArgs.port, clientArgs.host);
  }, (error, st) {
    print('Error: $error');
  });
}

Future<void> initializeTCPClient(int port, String host) async {
  /// First we connect to the server
  final socket = await Socket.connect(host, port);
  print('Connected to server $host:$port');

  socket.write('Hello, Server!');
  print('Writing Hello, Server!');

  Future.delayed(const Duration(seconds: 3), () {
    socket.write('Hello again, Server!');
  });

  /// Then we listen to the socket
  socket.cast<List<int>>().transform(utf8.decoder).listen(print);
}
