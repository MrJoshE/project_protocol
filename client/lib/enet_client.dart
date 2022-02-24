import 'dart:io';

import 'package:config/config.dart';

class EnetRequestOptions {
  final String? baseUrl;
  final int? port;

  const EnetRequestOptions({this.baseUrl, this.port});
}

class EnetClient {
  final Map<String, Socket> _persitedSockets = {};
  final EnetRequestOptions? options;

  EnetClient({this.options});

  Future<EnetResponse> static(
    String path, {
    Map<String, dynamic>? applicationHeaders,
    Map<String, dynamic>? headers,
    List<String>? files,
  }) async {
    if (options?.baseUrl != null) {
      path = '${options!.baseUrl}$path';
    }

    final request = _createRequest(
      path: path,
      headers: headers,
      body: null,
      files: files,
      applicationHeaders: applicationHeaders,
    );

    return await _sendRequest(request);
  }

  EnetRequest _createRequest({
    required String path,
    Map<String, dynamic>? applicationHeaders,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,

    /// Binary blobs of files (base64 encoded)
    List<String>? files,
  }) {
    final request = EnetRequest(
      path: path,
      headers: headers,
      body: body,
      files: files,
    );

    return request;
  }

  Future<EnetResponse> _sendRequest(EnetRequest request) async {
    /// 1. Create a socket connection with the sever.
    final socket = await Socket.connect(options?.baseUrl ?? request.path, options?.port ?? EnetConfig.DEFAULT_PORT);

    if (request.persist) {
      _persitedSockets[request.socketId!] = socket;
    }

    /// 2. Make a request to the server
    socket.write(request.toPayload());

    /// 3. Wait for the response
    final response = EnetResponse.fromRawResponse(await socket.first);

    /// 4. Close the socket connection
    ///
    if (!request.persist) {
      await socket.close();
    }

    return response;
  }

  // Stream List<int> listen(String socketId) {}

}
