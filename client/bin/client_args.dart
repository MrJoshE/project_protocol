import 'package:config/config.dart';

class ClientArgs {
  final int port;
  final String host;

  const ClientArgs({
    required this.port,
    required this.host,
  });

  factory ClientArgs.fromArguments(List<String> arguments) {
    int port;
    String host;
    try {
      port = int.tryParse(arguments[0]) ?? EnetConfig.DEFAULT_PORT;
    } catch (e) {
      port = EnetConfig.DEFAULT_PORT;
    }

    try {
      host = arguments[1];
    } catch (e) {
      host = EnetConfig.DEFAULT_HOST;
    }

    return ClientArgs(
      port: port,
      host: host,
    );
  }
}
