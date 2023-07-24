import '../models/servers.dart';
import 'package:args/args.dart';
import 'dart:async';
import '../models/database.dart';

Future<void> createServer(List<String> args) async {
  var parser = ArgParser();
  parser.addOption(
    "server",
    mandatory: true,
  );
  var results = parser.parse(args);
  
  
  var record = await Db.notNullFindRecord(
      "src/db/servers_users.db", "servers_users", "username");
  if(record.length != 0){
  Server server = Server();
  server.serverName = results["server"];
  server.createServer(results["server"]);
  }
  else{
    print("Login to access that feature");
  }

}
