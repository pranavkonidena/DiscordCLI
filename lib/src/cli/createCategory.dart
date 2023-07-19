import 'package:args/args.dart';
import '../models/servers.dart';

void createCat(List<String> arguments) {
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
  Category category = Category();
  category.createCategory(results);
}
