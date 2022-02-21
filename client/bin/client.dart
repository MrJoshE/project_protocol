import 'dart:async';
import 'dart:io';

import 'client_args.dart';

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

  /// Then we listen to the socket
  socket.listen((List<int> data) {
    print('Received data: ${String.fromCharCodes(data)}');
  }, onDone: () {
    print('Closing connection');
    socket.close();
  });
}
