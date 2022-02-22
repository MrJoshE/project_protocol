import 'dart:async';
import 'dart:io';

import 'package:config/config.dart';
import 'package:config/enet_config.dart';
import 'package:logging/logging.dart';

import 'connected_client.dart';
import 'exceptions.dart';

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
    _logger.shout('Listening on port ${_serverSocket.port}');

    _serverSocket.listen(onConnect, onDone: () {}, onError: onServerError);
  }

  /// This function will be called when a new connection is made.
  Future onConnect(Socket newSocketConnection) async {
    _logger.info('New connection from ${newSocketConnection.remoteAddress}');
    _connectedSockets[newSocketConnection.remoteAddress] = ConnectedClient(socket: newSocketConnection);
  }

  Future serverClose(dynamic data) async {}

  Future onServerError(dynamic error) async {}

  /// At the moment there are no checks to make sure the request is valid at all. Just that we are assuming the request is already cast to an EnetRequest when it tries to parse it.
  /// This is wrong and we need to accept the raw request and convert back to an EnetRequest.
  static Future<EnetParsingResponse<EnetRequest>> parseRequest(EnetRequest request) async {
    try {
      if (request.method == Method.POST) {
        throw RequestParsingException('POST requests are not supported');
      }

      return EnetParsingResponse.success(request);
    }

    /// If there is an error parsing the request we will return a failure response
    /// with the error message
    on RequestParsingException catch (e) {
      /// We will also log the error in the terminal for debugging purposes
      _logger.severe('Request parsing error: ${e.message}');
      return EnetParsingResponse.failure('Failed to parse request. ${e.message}');
    }

    /// If there is an error that is not related to parsing the request we will
    ///
    catch (e, st) {
      _logger.severe('Request parsing error: $e, $st');
      return EnetParsingResponse.failure('Failed to parse request. See logs for more information');
    }
  }

  /// Here we will try and stop the server
  void dispose() {
    if (_isDisposed || _serverSocket == null) {
      return;
    }

    _serverSocket!.close();
    _isDisposed = true;
  }
}
