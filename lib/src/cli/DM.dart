import 'package:args/args.dart';
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
  var results = parser.parse(arguments);
  if (results["dm"] == true) {
    var recipient = results["username"];
    
  } else {
    print("Please read the docs!");
  }
}
