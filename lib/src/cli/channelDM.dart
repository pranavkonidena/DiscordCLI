import 'dart:math';
import 'package:discord_cli/src/cli/dbFns/notNullFindRecord.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:sembast/sembast_io.dart';
import 'package:args/args.dart';
import '../models/user.dart';
import 'dbFns/equalFilter.dart';

Future<void> channelDM(List<String> arguments) async {
  var parser = ArgParser();
  parser.addFlag(
    "channelDM",
    abbr: "a",
  );
  parser.addOption(
    "channel",
    mandatory: true,
  );
  parser.addOption(
    "message",
    mandatory: true,
  );

  var results = parser.parse(arguments);
  Future<bool> isRes = equalfQueryfindFirst(
      "src/db/resChannels.db", "resChannels", "channel", results["channel"]);
  bool res = await isRes;
  var record = await notNullFindRecord(
      "src/db/servers_users.db", "servers_users", "username");
  if (record.length != 0) {
    if (!res) {
      loggedinUser user = loggedinUser();
      user.channelDM(results);
    } else {
      modUser user = modUser();
      user.restrictedDM(results);
    }
  } else {
    print("Log in to acces that feature");
  }
}
