import '../cli/insertDB.dart';
import 'package:discord_cli/src/models/user.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:sembast/utils/value_utils.dart';
import 'package:collection/collection.dart';
import '../cli/findInDatabase.dart';

class Server {
  List<String> serverUsers = [];
  List<Channel> channels = [];
  List<String> categories = [];
  late String serverName;

  // void create_Server(String servername) {
  //   Server server = Server();
  //   server.serverName = servername;
  //   Map data = {
  //     "server": serverName,
  //     "categories_channels": [],
  //   };
  //   insertDB("src/db/servers_channels.db", data, "servers_channels");

  //   print("Server created successfully.");
  // }

  void createServer(dynamic results) async {
    String dbPath = "src/db/servers_channels.db";
    String store_name = "servers_channels";
    Database db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store(store_name);
    int key;
    await db.transaction((txn) async {
      key = await store.add(txn, {
        "server": serverName,
        "categories_channels": [],
      });
    });
  }
}

class Category {
  List<Channel>? channels;
  createCategory(dynamic results) async {
    String server = results["server"];
    Database db =
        await databaseFactoryIo.openDatabase("src/db/servers_channels.db");
    var finder = Finder(filter: Filter.equals("server", results["server"]));
    var store = intMapStoreFactory.store("servers_channels");
    var findRecord = await store.findFirst(db, finder: finder);

    if (findRecord == null) {
      print("Server doesn't exist");
    }
    else{
      print(findRecord.value["categories_channels"]);
      dynamic map = cloneMap(findRecord.value);
      await store.delete(db, finder: finder);
      List <dynamic> duplicates = map["categories_channels"];
      var entry = {
        "categories": {
        results["category"]: [],
      },
    };
      duplicates.add(entry);
      map["categories_channels"] = duplicates;
      await store.add(db, map);
    }
    
  }
}

class Channel {
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
