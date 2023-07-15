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
  if (results['join'] == true) {
    String dbPath = "src/db/servers_users.db";
    Database db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('servers_users');
    int key;
    var finder = Finder(filter: Filter.equals("username", results["username"]));
    var findRecord = await store.findFirst(db, finder: finder);
    if (findRecord == null) {
      print("Please login before joining a server");
    } else {
      // findRecord[0].value.entries.last.value returns list of servers of a particular username.
      // findRecord[0].value.entries.last.value.add(results["server"]);
      dynamic map = cloneMap(findRecord.value);
      if (map["servers"].contains(results["server"])) {
        print(
            "User ${results['username']} has already joined the server ${results["server"]}");
      } else {
        await store.delete(db, finder: finder);
        List<dynamic> duplicates = [];
        duplicates = map["servers"];
        duplicates.add(results["server"]);
        map["servers"] = duplicates;
        await store.add(db, map);
        print(
            "User ${results["username"]} has joined the server ${results["server"]} successfully.");
      }
    }
  } else {
    print("See docs");
  }
}
