
import 'dart:math';
import '../cli/dbFns/notNullFindRecord.dart';
import 'package:args/args.dart';
import 'package:discord_cli/src/models/user.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

Future<void>  dm(List<String> arguments) async {
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
    var record = await notNullFindRecord(
      "src/db/servers_users.db", "servers_users", "username");
  if(record.length != 0){
  loggedinUser user = loggedinUser();
    user.sendDM(results);
  }
  else{
    print("Login to access that feature");
  }
    
  } else {
    print("Please read the docs!");
  }
}

void readDM() {
  loggedinUser user = loggedinUser();
  user.readDM();
}
