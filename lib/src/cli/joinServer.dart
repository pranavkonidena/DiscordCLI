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
    var finder_new =
        Finder(filter: Filter.equals("servers", results["server"]));
    var findRecord = await store.findFirst(db, finder: finder);
    var serverRecord = await store.findFirst(db, finder: finder_new);
    if (findRecord == null) {
      print("Please login before joining a server");
    } else {
      // findRecord[0].value.entries.last.value returns list of servers of a particular username.
      // findRecord[0].value.entries.last.value.add(results["server"]);
      if (serverRecord != null) {
        print(
            "User ${results["username"]} has already joined the server ${results["server"]}");
      } else {
        dynamic map = cloneMap(findRecord.value);
        await store.delete(db, finder: finder);
        map["servers"] = results["server"];
        await store.add(db, map);
        int key;
        print(
            "User ${results["username"]} has joined the server ${results["server"]} successfully.");
      }
    }
  } else {
    print("See docs");
  }
}
