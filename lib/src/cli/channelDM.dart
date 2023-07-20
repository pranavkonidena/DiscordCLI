import 'dart:math';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:sembast/sembast_io.dart';
import 'package:args/args.dart';
import '../models/user.dart';

void channelDM(List<String> arguments) async {
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
  Database db = await databaseFactoryIo.openDatabase("src/db/resChannels.db");
  var store = intMapStoreFactory.store("resChannels");
  var channelRecord = await store.findFirst(db , finder: Finder(filter: Filter.equals("channel", results["channel"])));
  if(channelRecord == null){
    loggedinUser user = loggedinUser();
    user.channelDM(results);
  }
  else{
    modUser user = modUser();
    user.restrictedDM(results);
  }
}
