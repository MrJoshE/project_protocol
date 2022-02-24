class EnetGenericResponse<T> {
  final bool success;

  final T? content;

  final String? message;

  EnetGenericResponse.success(this.content)
      : success = true,
        message = null;

  EnetGenericResponse.failure(this.message)
      : success = false,
        content = null;
}
