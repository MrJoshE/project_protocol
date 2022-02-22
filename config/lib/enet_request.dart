enum EnetRequestType { static, dynamic }

enum Method { GET, POST, PUT, DELETE, BATCH }

class EnetRequest {
  /// We require the path of the request (e.g. /api/v1/users/1)
  final String path;

  /// We require the method of the request (e.g. GET, POST, PUT, DELETE)
  final Method method;

  /// We require the type of the request (e.g. static, dynamic)
  /// Static requests are made once and cached
  /// Dynamic requests are made every time the request is made
  final EnetRequestType type;

  /// Reflection of a HTTP header however instead of a string we use a Map
  final Map<String, String> head;

  final List<String>? files;

  const EnetRequest({
    required this.path,
    required this.method,
    this.files,
    this.type = EnetRequestType.static,
    this.head = const {},
  });
}
