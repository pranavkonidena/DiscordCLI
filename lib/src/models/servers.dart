import 'dart:io';

import 'package:discord_cli/src/models/user.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:sembast/utils/value_utils.dart';
import 'package:collection/collection.dart';

class Server {
  List<String> serverUsers = [];
  List<String> channels = [];
  late String serverName;
}

class Channel extends Server {
  List<String> channelUsers = [];
  late String channelName;
  late String channelCategory;

  createChannel(dynamic results) async {
    Function eq = const ListEquality().equals;
    String dbPath = "src/db/servers_channels.db";
    Database db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('servers_users');
    var finder = Finder(filter: Filter.notNull("servers"));
    var findRecord = await store.find(db, finder: finder);
    List<dynamic> serverList =
        findRecord[findRecord.length - 1].value["servers"] as List;
    if (serverList.contains(results["server"])) {
      Database db_lUsers =
          await databaseFactoryIo.openDatabase("src/db/servers_users.db");
      var finder =
          Finder(filter: Filter.equals("username", results["username"]));
      var userRecord = await store.findFirst(db_lUsers, finder: finder);
      if (userRecord == null) {
        print("Not a valid user!");
      } else {
        dynamic map = cloneMap(userRecord.value);
        List<dynamic> duplicates = [];
        print(map);
        duplicates = map["channels"];
        duplicates.add(results["channel"]);
        map["channels"] = duplicates;
         await store.delete(db_lUsers, finder: finder);
        await store.add(db_lUsers, map);
        print(
            "User ${results["username"]} joined channel ${results["channel"]} succesfully");
      }
    } else {
      print("Please enter a valid server!");
    }
  }
}
