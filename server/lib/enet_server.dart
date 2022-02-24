import 'dart:async';
import 'dart:io';

import 'package:config/config.dart';
import 'package:config/enet_config.dart';
import 'package:logging/logging.dart';

import 'connected_client.dart';

class EnetServerArgs {
  /// The port to listen on.
  ///
  /// If not specified, the server will listen on port [ENET_DEFAULT_PORT].
  final int port;

  /// The amount of time between each server response milliseconds
  final int timeout;

  const EnetServerArgs({
    this.port = EnetConfig.DEFAULT_PORT,
    this.timeout = 0,
  });
}

class EnetServer {
  ServerSocket? _serverSocket;

  static final Logger _logger = Logger('EnetServer');

  /// Map from IP address to ConnectedClient, keeping this for stateful sockets.
  final Map<InternetAddress, ConnectedClient> _connectedSockets = {};

  /// When requests come in we will put them in the buffer so that if we want to add a processing
  /// timeout to stop the server from being overwhelmed we can do so.
  // final List<dynamic> _requestBuffer = [];

  // final List<dynamic> _responseBuffer = [];

  bool _isDisposed = false;

  /// Here we will try and start the server
  Future initialize({EnetServerArgs? args}) async {
    args = args ?? EnetServerArgs();

    final _serverSocket = await ServerSocket.bind(InternetAddress.loopbackIPv4, args.port);
    _logger.shout('Listening on ${InternetAddress.loopbackIPv4.address}:${_serverSocket.port}');

    _serverSocket.listen(onConnect, onDone: onServerClose, onError: onServerError);
  }

  /// This function will be called when a new connection is made.
  Future onConnect(Socket newSocketConnection) async {
    _connectedSockets[newSocketConnection.remoteAddress] = ConnectedClient(socket: newSocketConnection);
    _logger.info('New connection from ${newSocketConnection.remoteAddress} [${_connectedSockets.length}]');
  }

  /// This function will be called when the server is closed.
  Future onServerClose() async {
    _logger.info('Closing all [${_connectedSockets.length}] socket connections...');
    // Close all socket connections
    for (final client in _connectedSockets.values) {
      await client.socket.close();
    }
    _logger.info('All socket connections have been closed.');
  }

  /// This function will be called when the server has an error.
  Future onServerError(Object? error, StackTrace stackTrace) async {
    _logger.severe('Server error: $error. Stack traace: $stackTrace');
  }

  /// At the moment there are no checks to make sure the request is valid at all. Just that we are assuming the request is already cast to an EnetRequest when it tries to parse it.
  /// This is wrong and we need to accept the raw request and convert back to an EnetRequest.

  /// Here we will try and stop the server
  void dispose() {
    if (_isDisposed || _serverSocket == null) {
      return;
    }

    _serverSocket!.close();
    _isDisposed = true;
  }
}
