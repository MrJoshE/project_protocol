import 'package:config/config_impl.dart';

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
      port = int.tryParse(arguments[0]) ?? Config.DEFAULT_PORT;
    } catch (e) {
      port = Config.DEFAULT_PORT;
    }

    try {
      host = arguments[1];
    } catch (e) {
      host = Config.DEFAULT_HOST;
    }

    return ClientArgs(
      port: port,
      host: host,
    );
  }
}
