import 'package:config/enet_generic_response.dart';
import 'package:config/enet_request.dart';
import 'package:logging/logging.dart';

import 'exceptions.dart';

class RequestParser {
  static final Logger _logger = Logger('RequestParser');

  static EnetGenericResponse<EnetRequest> parseRequest(List<int> data) {
    try {
      final request = EnetRequest.fromBytes(data);
      if (request.type == EnetRequestType.dynamic) {
        throw RequestParsingException('Dynamic requests are not supported');
      }

      return EnetGenericResponse.success(request);
    }

    /// If there is an error parsing the request we will return a failure response
    /// with the error message
    on RequestParsingException catch (e) {
      /// We will also log the error in the terminal for debugging purposes
      _logger.severe('Request parsing error: ${e.message}');
      return EnetGenericResponse.failure('Failed to parse request. ${e.message}');
    }

    /// If there is an error that is not related to parsing the request we will
    ///
    catch (e, st) {
      _logger.severe('Request parsing error: $e, $st');
      return EnetGenericResponse.failure('Failed to parse request. See logs for more information');
    }
  }
}
