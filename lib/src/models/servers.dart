import 'dart:io';
import '../models/channels.dart';
import '../models/database.dart';

List type = ["text", "announcement", "voice", "stage", "rules"];

class Server {
  List<String> serverUsers = [];
  List<Channel> channels = [];
  List<String> categories = [];
  late String serverName;

  void createServer(dynamic results) async {
    String dbPath = "src/db/servers_channels.db";
    String store_name = "servers_channels";
    dynamic data = {
      "server": serverName,
      "categories_channels": [],
    };
    Db.addToDBTxn(dbPath, store_name, data);
    print("Server created succesfully");
  }

  void printCategory(dynamic results) async {
    var findRecord = await Db.equalQueryFindFirstRecord(
        "src/db/servers_channels.db",
        "servers_channels",
        "server",
        results["server"]);
    if (findRecord == null) {
      print("Server entered is invalid");
    } else {
      List categories = findRecord.value["categories_channels"] as List;
      print("Printing categories in server ${results["server"]}");
      for (int i = 0; i < categories.length; i++) {
        Map indiCat = categories[i]["categories"] as Map;
        print(indiCat.keys.first);
        var duration = const Duration(seconds: 2);
        sleep(duration);
      }
    }
  }

  void printModUser(dynamic results) async {
    var findRecord =
        await Db.notNullFindRecord("src/db/mod_users.db", "mod_users", "servers");
    print("Printing mod users in server ${results["server"]}");
    for (int i = 0; i < findRecord.length; i++) {
      List<dynamic> temp = findRecord[i].value["servers"] as List;
      if (temp.contains(results["server"])) {
        print(findRecord[i].value["username"]);
      }
      
    }
  }
}



