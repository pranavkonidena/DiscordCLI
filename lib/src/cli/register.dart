// No bugs in register feature
import 'dart:convert';
import 'package:args/args.dart';
import 'package:crypto/crypto.dart';
import 'package:discord_cli/src/models/database.dart';
import 'dart:async';
import '../models/user.dart';

Future<void>  registerUser(List<String> args) async {
  var parser = ArgParser();
  parser.addOption(
    "username",
    mandatory: true,
    abbr: 'u',
  );
  parser.addOption(
    "password",
    mandatory: true,
    abbr: "p",
  );
  parser.addOption(
    "role",
    mandatory: false,
    defaultsTo: "member",
  );
  parser.addFlag("register", abbr: "r");
  try {
    var results = parser.parse(args);
    if (results["register"] == true) {
      String dbPath = "src/db/users.db";
      var bytes = utf8.encode(results['password']);
      var digest = sha256.convert(bytes);
      bool isRegBef = await Db.equalQueryfind(
          dbPath, "users", "username", results["username"]);
      if (!isRegBef) {
        dynamic data = {
          "username": results['username'],
          "messages": [],
          "channels": [],
          "password": digest.toString()
        };
        Db.addToDBTxn(dbPath, "users", data);
        if (results["role"] == "mod") {
          String dbPathMod = "src/db/mod_users.db";
          dynamic data = {
            "username": results['username'],
            "servers": [],
            "channels": [],
          };
          Db.addToDBTxn(dbPathMod, "mod_users", data);
        }
        if (results["role"] == "creator") {
          String dbPathMod = "src/db/creator_users.db";
          dynamic data = {
            "username": results["username"],
          };
          Db.addToDBTxn(dbPathMod, "creator_users", data);
        }
        print("User ${results["username"]} registered succesfully");
        User user = User();
        user.username = results['username'];
      } else {
        print("User ${results["username"]} was registered previously");
      }
    } else {
      print("Read docs");
    }
  } catch (e) {
    print("Error occoured: ${e}");
  }
}

void main(List<String> args) {
  registerUser(args);
}
