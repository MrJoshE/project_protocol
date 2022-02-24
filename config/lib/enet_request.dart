import 'dart:convert';

enum EnetRequestType { static, dynamic }

class EnetRequest {
  final String? socketId;

  /// We require the path of the request (e.g. /api/v1/users/1)
  final String path;

  /// We require the type of the request (e.g. static, dynamic)
  /// Static requests are made once and cached
  /// Dynamic requests are made every time the request is made
  final EnetRequestType type;

  /// Reflection of a HTTP header however instead of a string we use a Map
  /// this is used for low level information about the client
  /// such as IP address and user agent
  final Map<String, dynamic>? headers;

  final Map<String, dynamic>? applicationHeaders;

  final Map<String, dynamic>? body;

  final List<String>? files;

  final bool persist;

  EnetRequest({
    required this.path,
    this.socketId,
    this.files,
    this.type = EnetRequestType.static,
    this.headers = const {},
    this.applicationHeaders = const {},
    this.body = const {},
    this.persist = false,
  }) {
    if (persist) {
      assert(socketId != null, 'Persisted sockets require a socket id to identify them client and sever side.');
    }
  }

  factory EnetRequest.fromBytes(List<int> data) {
    final buffer = utf8.decode(data);

    print(buffer + '\n');

    return EnetRequest(
      path: 'NOT VALID PATH',
    );
  }

  String toPayload() {
    final buffer = StringBuffer();

    buffer.write('|P:$path');

    buffer.write(
        '|T:${type.toString().split('.')[1].toUpperCase().length}>${type.toString().split('.')[1].toUpperCase()}');

    return buffer.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'type': type.toString().split('.')[1].toUpperCase(),
      'headers': headers,
      'applicationHeaders': applicationHeaders,
      'body': body,
      'files': files,
      'persist': persist,
    };
  }
}
