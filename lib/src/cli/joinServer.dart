import '../models/database.dart';
import '../models/user.dart';
import 'package:args/args.dart';
import 'dart:async';

Future<void> addToDb(List<String> args) async {
  var parser = ArgParser();
  parser.addOption(
    "server",
    mandatory: false,
    abbr: "s",
  );
  parser.addOption(
    "username",
    abbr: "u",
    mandatory: true,
  );
  parser.addFlag(
    "join",
    abbr: "j",
    defaultsTo: false,
  );

  var results = parser.parse(args);
  String dbPath = "src/db/servers_users.db";
  bool isLogin = await Db.equalQueryfind(
      dbPath, "servers_users", "username", results["username"]);
  if (!isLogin) {
    print("Please log in to join a server");
  } else {
    loggedinUser user = loggedinUser();
    user.joinServer(results);
  }
}
