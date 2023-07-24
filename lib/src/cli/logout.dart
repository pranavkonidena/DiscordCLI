import 'package:args/args.dart';
import '../models/user.dart';

Future<void>  logoutUser(List<String> arguments) async {
  var parser = ArgParser();
  parser.addFlag(
    "logout",
    defaultsTo: false,
  );

  parser.addOption(
    "username",
    abbr: "u",
    mandatory: false,
  );

  var results = parser.parse(arguments);
  loggedinUser user = loggedinUser();
  user.logout(results);
}
