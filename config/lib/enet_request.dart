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
  final Map<String, String>? headers;

  final Map<String, String>? applicationHeaders;

  final Map<String, String>? body;

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

  factory EnetRequest.fromBuffer(List<int> data) {
    final decoded = utf8.decode(data);

    print(decoded);

    final methodString = decoded.substring(decoded.indexOf('<\$M>') + 4, decoded.indexOf('</\$M>'));

    print('methodString: $methodString');

    return EnetRequest(
      path: 'NOT VALID PATH',
    );
  }

  List<int> convertIntoRawRequest() {
    final buffer = StringBuffer();

    buffer.write('<\$P>$path</\$P>');

    buffer.write('<\$T>${type.toString().split('.')[1].toUpperCase()}</\$T>');

    return utf8.encode(buffer.toString());
  }
}
