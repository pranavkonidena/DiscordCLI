import 'package:args/args.dart';
import '../models/servers.dart';
import '../models/database.dart';

Future<void>  printCategory(List<String> arguments) async {
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

  var record = await Db.notNullFindRecord(
      "src/db/servers_users.db", "servers_users", "username");
  if (record.length != 0) {
    Server server = Server();
    server.printCategory(results);
  } else {
    print("Login to access that feature");
  }
}
