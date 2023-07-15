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
  loggedinUser user = loggedinUser();
  user.logout(results);
}
