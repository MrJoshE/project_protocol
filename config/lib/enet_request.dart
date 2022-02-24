import 'dart:convert';

enum EnetRequestType { static, dynamic }

enum Method { GET, POST, PUT, DELETE, BATCH }

class EnetRequest {
  final String? socketId;

  /// We require the path of the request (e.g. /api/v1/users/1)
  final String path;

  /// We require the method of the request (e.g. GET, POST, PUT, DELETE)
  final Method method;

  /// We require the type of the request (e.g. static, dynamic)
  /// Static requests are made once and cached
  /// Dynamic requests are made every time the request is made
  final EnetRequestType type;

  /// Reflection of a HTTP header however instead of a string we use a Map
  final Map<String, String>? head;

  final Map<String, String>? body;

  final List<String>? files;

  final bool persist;

  EnetRequest({
    required this.path,
    required this.method,
    this.socketId,
    this.files,
    this.type = EnetRequestType.static,
    this.head = const {},
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

    return EnetRequest(path: 'NOT VALID PATH', method: Method.GET);
  }

  List<int> convertIntoRawRequest() {
    final buffer = StringBuffer();

    buffer.write('<\$P>$path</\$P>');

    buffer.write('<\$M>${method.toString().split('.')[1].toUpperCase()}</\$M>');

    return utf8.encode(buffer.toString());
  }
}
