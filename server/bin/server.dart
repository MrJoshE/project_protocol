import 'package:logging/logging.dart';
import 'package:server/enet_server.dart';

Future main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final server = EnetServer();

  await server.initialize();
}
