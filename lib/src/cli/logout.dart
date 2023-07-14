import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';
import 'package:args/args.dart';
import '../models/user.dart';

void logoutUser(List<String> arguments) async {
  var parser = ArgParser();
  parser.addFlag(
    "logout",
    defaultsTo: false,
  );

  parser.addOption(
    "username",
    abbr: "u",
    mandatory: true,
  );

  var results = parser.parse(arguments);
  if (results['logout'] == true) {
    try {
      String dbPath = "src/db/users.db";
      Database db = await databaseFactoryIo.openDatabase(dbPath);
      var store = intMapStoreFactory.store('users');
      var finder =
          Finder(filter: Filter.equals("username", results["username"]));
      var findRecord = await store.find(db, finder: finder);
      if(findRecord.isEmpty){
        print("User not found. Please register before logging out.");
      }
      else{
        User user = User();
        user.username = results['username'];
        print("User ${user.username} logged out succesfully.");
      }
    } catch (e) {
      print(e);
    }
  } else {
    print("Read docs");
  }
}
