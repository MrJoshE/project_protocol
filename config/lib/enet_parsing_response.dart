class EnetParsingResponse<T> {
  final bool success;

  final T? content;

  final String? message;

  EnetParsingResponse.success(this.content)
      : success = true,
        message = null;

  EnetParsingResponse.failure(this.message)
      : success = false,
        content = null;
}
