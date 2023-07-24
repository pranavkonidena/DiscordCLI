import '../models/servers.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/utils/value_utils.dart';
import '../models/database.dart';



class Channel {
  List<String> channelUsers = [];
  late String channelName;
  late String channelCategory;

  void createChannel(dynamic results) async {
    var record = await Db.equalQueryFindFirstRecord("src/db/creator_users.db",
        "creator_users", "username", results["username"]);
    if (record == null) {
      print("Creator role required");
    } else {
      if (type.contains(results["type"])) {
        String dbPath = "src/db/servers_channels.db";
        Database db = await databaseFactoryIo.openDatabase(dbPath);
        var finder = Finder(filter: Filter.equals("server", results["server"]));
        var store = intMapStoreFactory.store("servers_channels");
        var findRecord = await Db.equalQueryFindFirstRecord(
            dbPath, "servers_channels", "server", results["server"]);
        try {
          var map = cloneMap(findRecord!.value);
          var list_map = map["categories_channels"] as List;
          var itemToChange;
          if (list_map.length > 1) {
            itemToChange = list_map[list_map.length - 1];
          } else {
            itemToChange = list_map[0];
          }
          try {
            (itemToChange["categories"][results["category"]] as List)
                .insert(0, results["channel"]);
            await store.delete(db, finder: finder);
            map["categories_channels"] = list_map;
            await store.add(db, map);
            try {
              Database db_users =
                  await databaseFactoryIo.openDatabase("src/db/users.db");
              var finder_users = Finder(
                  filter: Filter.equals("username", results["username"]));
              var store_users = intMapStoreFactory.store("users");
              var userRecord = await Db.equalQueryFindFirstRecord(
                  "src/db/users.db", "users", "username", results["username"]);
              var map = cloneMap(userRecord!.value);
              List duplicates = [];
              duplicates = map["channels"] as List;
              duplicates.add(results["channel"]);
              map["channels"] = duplicates;
              await store_users.delete(db_users, finder: finder_users);
              await store_users.add(db_users, map);
              print("Channel joined succesfully!");
              if (results["restrict"] == true ||
                  results["type"] == "text" ||
                  results["type"] == "announcement") {
                Database resChannels = await databaseFactoryIo
                    .openDatabase("src/db/resChannels.db");
                var storeResChannels = intMapStoreFactory.store("resChannels");
                await storeResChannels.add(resChannels, {
                  "channel": results["channel"],
                });
              }
            } catch (e) {
              print("Invalid user");
            }
          } catch (e) {
            print("That category doesn't exist.");
          }
        } catch (e) {
          print("Category is not added in server");
        }
      } else {
        print("Invalid channel type entered!");
      }
    }
  }
}
