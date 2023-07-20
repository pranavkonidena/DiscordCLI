import '../cli/insertDB.dart';
import 'package:discord_cli/src/models/user.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:sembast/utils/value_utils.dart';
import 'package:collection/collection.dart';
import '../cli/findInDatabase.dart';

enum type { text, announcement, voice, stage, rules }

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
    print("Server created succesfully");
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
    } else {
      dynamic map = cloneMap(findRecord.value);
      await store.delete(db, finder: finder);
      List<dynamic> duplicates = map["categories_channels"];
      var entry = {
        "categories": {
          results["category"]: [],
        },
      };
      duplicates.add(entry);
      map["categories_channels"] = duplicates;
      await store.add(db, map);
      print("Category added succesfully");
    }
  }
}

class Channel {
  List<String> channelUsers = [];
  late String channelName;
  late String channelCategory;

  void createChannel(dynamic results) async {
    //Query reg server , if server exists , user mein channels mein append krdo and server ke entry mein channel append krdo.
    String dbPath = "src/db/servers_channels.db";
    Database db = await databaseFactoryIo.openDatabase(dbPath);
    var finder = Finder(filter: Filter.equals("server", results["server"]));
    var store = intMapStoreFactory.store("servers_channels");
    var findRecord = await store.findFirst(db, finder: finder);
    try {
      var map = cloneMap(findRecord!.value);
      await store.delete(db , finder: finder);
      var list_map = map["categories_channels"] as List;
      var itemToChange = list_map[list_map.length - 1];
      try {
        (itemToChange["categories"][results["category"]] as List).insert(0,results["channel"]);
        map["categories_channels"] = list_map;
        await store.add(db, map);
        try {
          Database db_users = await databaseFactoryIo.openDatabase("src/db/servers_users.db");
          var finder_users = Finder(filter: Filter.equals("username" , results["username"]));
          var store_users = intMapStoreFactory.store("servers_users");
          var userRecord = await store_users.findFirst(db_users , finder: finder_users);
          print(userRecord!.value["channels"]);
          var map = cloneMap(userRecord.value);
          await store_users.delete(db_users , finder: finder_users);
          List  duplicates = [];
          duplicates = map["channels"] as List;
          duplicates.add(results["channel"]);
          map["channels"] = duplicates;
          await store_users.add(db_users, map);
        } catch (e) {
          print("Invalid user");
        }
        print("Channel joined succesfully!");
      } catch (e) {
        print("That category doesn't exist.");
      }
    } catch (e) {
      print("Server doesn't exist.");
    }
  }
}
