import '../models/servers.dart';
import '../models/user.dart';
import 'package:args/args.dart';
import '../cli/dbFns/notNullFindRecord.dart';

Future<void>  createChannel(List<String> arguments) async {
  var parser = ArgParser();
  parser.addOption(
    "channel",
    mandatory: true,
  );
  parser.addOption(
    "server",
    mandatory: true,
  );
  parser.addOption(
    "category",
    mandatory: false,
    defaultsTo: "null",
  );
  parser.addFlag(
    "create",
    abbr: "c",
    defaultsTo: false,
  );
  parser.addOption(
    "username",
    abbr: "u",
    mandatory: true,
  );
  parser.addFlag(
    "restrict",
    defaultsTo: false,
  );
  parser.addOption(
    "type",
    mandatory: true,
  );

  var results = parser.parse(arguments);

  if (results["create"] == true) {
    var record = await notNullFindRecord(
      "src/db/servers_users.db", "servers_users", "username");
  if(record.length != 0){
   Channel channel = Channel();
    channel.createChannel(results);
  }
  else{
    print("Login to access that feature");
  }
  } else {
    print("Please read the docs!");
  }
}
