import 'package:args/args.dart';
import 'package:discord_cli/src/models/user.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

void dm(List<String> arguments) {
  var parser = ArgParser();
  parser.addFlag(
    "dm",
    abbr: "d",
    defaultsTo: false,
  );
  parser.addOption(
    "recipient",
    mandatory: true,
  );
  parser.addOption(
    "message",
    abbr: "m",
    mandatory: true,
  );
  var results = parser.parse(arguments);
  if (results["dm"] == true) {
    loggedinUser user = loggedinUser();
    user.sendDM(results);
  } else {
    print("Please read the docs!");
  }
}