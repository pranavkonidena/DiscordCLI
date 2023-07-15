import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../models/user.dart';
import '../models/servers.dart';
import 'package:args/args.dart';
import 'dart:async';
import 'package:sembast/utils/value_utils.dart';

void addToDb(List<String> args) async {
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
  Database db = await databaseFactoryIo.openDatabase(dbPath);
  var store = intMapStoreFactory.store('servers_users');
  var finder = Finder(filter: Filter.equals("username", results["username"]));
  var findRecord = await store.find(db, finder: finder);
  if (findRecord.isEmpty) {
    print("Please log in to join a server");
  } else {
    loggedinUser user = loggedinUser();
    user.joinServer(results);
  }
}
