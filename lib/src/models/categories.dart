import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/utils/value_utils.dart';
import '../models/database.dart';
import '../models/channels.dart';

class Category {
  List<Channel>? channels;
  void createCategory(dynamic results) async {
    String server = results["server"];
    Database db =
        await databaseFactoryIo.openDatabase("src/db/servers_channels.db");
    var finder = Finder(filter: Filter.equals("server", results["server"]));
    var store = intMapStoreFactory.store("servers_channels");
    var findRecord = await Db.equalQueryFindFirstRecord(
        "src/db/servers_channels.db",
        "servers_channels",
        "server",
        results["server"]);
    if (findRecord == null) {
      print("Server doesn't exist");
    } else {
      dynamic map = cloneMap(findRecord.value);
      List<dynamic> duplicates = map["categories_channels"];
      var entry = {
        "categories": {
          results["category"]: [],
        },
      };
      duplicates.add(entry);
      map["categories_channels"] = duplicates;

      try {
        await store.delete(db, finder: finder);
        await store.add(db, map);
      } catch (e) {
        await store.add(db, map);
      }
      print("Category added succesfully");
    }
  }
}