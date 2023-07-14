// No bugs in register feature
import 'dart:convert';
import 'package:args/args.dart';
import 'package:crypto/crypto.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'dart:async';
import 'package:cryptography/cryptography.dart';

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
  parser.addFlag("register", abbr: "r");
  try {
    var results = parser.parse(args);
    if (results["register"] == true) {
      String dbPath = "/Users/Pranav_1/Desktop/dev/IMG_Assignment_Dart/lib/src/models/users.db";
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
          key = await store.add(txn,
              {"username": results['username'], "password": digest.toString()});
        });
        print("User ${results["username"]} registered succesfully");
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
