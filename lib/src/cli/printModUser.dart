import 'package:args/args.dart';
import '../models/servers.dart';

void printModUser(List<String> arguments) async {
  var parser = ArgParser();
  parser.addOption(
    "print",
    abbr: "p",
  );
  parser.addFlag(
    "mU",
    defaultsTo: false,
  );
  parser.addOption(
    "server",
    mandatory: true,
  );

  var results = parser.parse(arguments);
  Server server = Server();
  server.printModUser(results);
}
