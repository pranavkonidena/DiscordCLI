import 'dart:io';

import 'package:discord_cli/src/models/user.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:sembast/utils/value_utils.dart';

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
    String dbPath = "src/db/servers_users.db";
    Database db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('servers_users');
    var finder = Finder(filter: Filter.notNull("username")); // For logged in
    var finder_server =
        Finder(filter: Filter.matches("servers", results["server"]));
    var findRecord_users = await store.find(db, finder: finder); // For log in
    var findRecord_servers = await store.find(db, finder: finder_server);
    if (findRecord_users.isEmpty) {
      print("Please log in before creating a channel.");
    } else {
      if (findRecord_servers.isEmpty) {
        print("No server");
      } else {
        print("Server");
      }
    }
  }
}
