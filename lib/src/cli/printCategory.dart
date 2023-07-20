import 'package:args/args.dart';
import '../models/servers.dart';

void printCategory(List<String> arguments) {
  var parser = ArgParser();
  parser.addOption(
    "print",
    abbr: "p",
  );
  parser.addFlag(
    "category",
    defaultsTo: false,
  );
  parser.addOption(
    "server",
    mandatory: true,
  );

  var results = parser.parse(arguments);
  Server server = Server();
  server.printCategory(results);
}
