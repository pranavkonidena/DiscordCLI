// No bugs in register feature
import 'dart:convert';
import 'package:args/args.dart';
import 'package:crypto/crypto.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'dart:async';
import 'package:cryptography/cryptography.dart';
import '../models/user.dart';

void registerUser(List<String> args) async {
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
      Database db = await databaseFactoryIo.openDatabase(dbPath);
      var store = intMapStoreFactory.store('users');
      var bytes = utf8.encode(results['password']);
      var digest = sha256.convert(bytes);
      int key;
      var finder =
          Finder(filter: Filter.equals("username", results["username"]));
      var findRecord = await store.find(db, finder: finder);
      if (findRecord.isEmpty) {
        await db.transaction((txn) async {
          key = await store.add(txn, {
            "username": results['username'],
            "messages": [],
            "channels": [],
            "password": digest.toString()
          });
        });
        if (results["role"] == "mod") {
          String dbPathMod = "src/db/mod_users.db";
          Database dbMod = await databaseFactoryIo.openDatabase(dbPathMod);
          var store_mod = intMapStoreFactory.store("mod_users");
          int key_mod;
          await dbMod.transaction((txn) async {
            key_mod = await store.add(txn, {
              "username": results['username'],
              "servers": [],
              "channels": [],
            });
          });
        }
        if (results["role"] == "creator") {
          String dbPathMod = "src/db/creator_users.db";
          Database dbmod = await databaseFactoryIo.openDatabase(dbPathMod);
          var store_mod = intMapStoreFactory.store("creator_users");
          int key;
          await dbmod.transaction((transaction) async {
            key = await store_mod.add(transaction, {
              "username": results["username"],
            });
          });
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
