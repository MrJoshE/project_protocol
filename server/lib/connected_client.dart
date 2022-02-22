import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

const Uuid UUID = Uuid();

class ConnectedClient {
  /// The socket connection of the client.
  final Socket socket;
  static final uuid = UUID.v1();
  static final Logger _logger = Logger('ConnectedClient $uuid');

  ConnectedClient({
    required this.socket,
  }) {
    _logger.info('Client $uuid connected');
    // Listen for incoming data.
    socket.listen(onRawRequestRecieved, onDone: () {
      socket.close();
    });
  }

  void onRawRequestRecieved(List<int> data) {
    _logger.info('[$uuid] Received data: ${utf8.decode(data)}');

    _logger.info('[$uuid] Sending data: ${utf8.decode(data)}');
    socket.write(utf8.decode(data));
  }
}
