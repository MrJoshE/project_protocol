class RequestParsingException implements Exception {
  final String message;
  const RequestParsingException(this.message);
}

class RequestCastingException implements Exception {}
