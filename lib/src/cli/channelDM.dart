import 'dart:math';

import 'package:args/args.dart';
import '../models/user.dart';

void channelDM(List<String> arguments) {
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
  loggedinUser user = loggedinUser();
  user.channelDM(results);
}
