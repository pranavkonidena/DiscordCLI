import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';
import 'package:args/args.dart';
import 'register.dart';
import 'dart:convert';

void loginUser(List<String> args) async {
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

  try {
    var results = parser.parse(args);
    if (results['login'] == true) {
      String dbPath =
          "/Users/Pranav_1/Desktop/dev/IMG_Assignment_Dart/lib/src/models/users.db";
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
          print("User ${results['username']} logged in succesfully");
        } else {
          print("Please enter the correct password");
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
