import 'package:args/args.dart';
import '../models/database.dart';
import '../models/categories.dart';

Future<void>  createCat(List<String> arguments) async {
  var parser = ArgParser();
  parser.addOption(
    "server",
    mandatory: true,
  );
  parser.addOption(
    "category",
    mandatory: true,
  );
  var results = parser.parse(arguments);
  var record = await Db.notNullFindRecord(
      "src/db/servers_users.db", "servers_users", "username");
  if (record.length != 0) {
    Category category = Category();
    category.createCategory(results);
  } else {
    print("Login to access that feature");
  }
}
