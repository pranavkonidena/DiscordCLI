import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../models/user.dart';
import '../models/servers.dart';
import 'package:args/args.dart';
import 'dart:async';
import 'package:sembast/utils/value_utils.dart';

createServer(List<String> args) {
  var parser = ArgParser();
  parser.addOption(
    "server",
    mandatory: true,
  );
  var results = parser.parse(args);
  Server server = Server();
  server.serverName = results["server"];
  server.createServer(results["server"]);
  
}
