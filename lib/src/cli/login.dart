import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';
import 'package:args/args.dart';
import '../models/user.dart';
import 'dart:convert';
import '../cli/joinServer.dart';

loginUser(List<String> args) async {
  var parser = ArgParser();
  parser.addFlag(
    "login",
    abbr: "l",
    defaultsTo: false,
  );

  parser.addOption(
    "username",
    abbr: "u",
    mandatory: true,
  );

  parser.addOption(
    "password",
    abbr: "p",
    mandatory: true,
  );

  parser.addOption(
    "role",
    mandatory: false,
    defaultsTo: "member",
  );
  var results = parser.parse(args);
  try {
    if (results['login'] == true) {
      String dbPath = "src/db/users.db";
      Database db = await databaseFactoryIo.openDatabase(dbPath);
      var store = intMapStoreFactory.store('users');
      var finder =
          Finder(filter: Filter.equals("username", results["username"]));
      var findRecord = await store.find(db, finder: finder);
      if (findRecord.isEmpty) {
        print("Please register before logging in");
      } else {
        var hashedPassword = findRecord[0].value.entries.last.value;
        var bytes = utf8.encode(results['password']);
        var digest = sha256.convert(bytes);
        if (digest.toString() == hashedPassword) {
          loggedinUser user = loggedinUser(results["role"]);
          user.username = results['username'];
          String dbPath = "src/db/servers_users.db";
          Database db = await databaseFactoryIo.openDatabase(dbPath);
          var store = intMapStoreFactory.store('servers_users');
          int key;
          await db.transaction((txn) async {
            key = await store.add(txn, {
              "username": results['username'],
              "servers" : null,
            });
          });
          print("User ${results['username']} logged in succesfully");
          
        } else {
          print("Please enter the correct password");
          return null;
        }
      }
    } else {
      print("Read docs");

    }
  } catch (e) {
    print(e);
    // exit(2);
  }
}

void main(List<String> args) {
  loginUser(args);
}
