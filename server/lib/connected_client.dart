import 'dart:io';

import 'package:config/config.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'request_parser.dart';

const Uuid UUID = Uuid();

class ConnectedClient {
  /// The socket connection of the client.
  final Socket socket;
  static final uuid = UUID.v1();
  static final Logger _logger = Logger('ConnectedClient $uuid');

  ConnectedClient({
    required this.socket,
  }) {
    _logger.info('Client $uuid connected ');
    // Listen for incoming data.
    socket.listen(
      onRequest,
      onDone: () {
        socket.close();
      },
      onError: (error) {
        _logger.severe('Client $uuid error $error');
      },
    );
  }

  void onRequest(List<int> data) {
    // _logger.info('[$uuid] Received data: ${utf8.decode(data)}');
    print('\n\n');
    final request = RequestParser.parseRequest(data);

    if (request.success) {
      socket.write(EnetResponse.success());
    } else {
      _logger.severe('There was an error whilst parsing request: ${request.message}');
      socket.write(EnetResponse.error());
    }
  }
}
