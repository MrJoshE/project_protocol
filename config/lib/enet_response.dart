// import 'dart:convert';

import 'dart:convert';

class EnetResponse {
  final int status;
  final List<String> files;

  EnetResponse({
    required this.status,
    this.files = const [],
  });

  factory EnetResponse.fromRawResponse(List<int> data) {
    final _ = utf8.decode(data);

    final status = 1337;
    return EnetResponse(
      status: status,
    );
  }

  factory EnetResponse.success() => EnetResponse(
        status: 1337,
      );

  factory EnetResponse.error({
    String? error,
    String? message,
    int? code,
  }) =>
      EnetResponse(
        status: code ?? -1,
      );
}
