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
    "register",
    mandatory: true,
    abbr: 'r',
  );
  parser.addOption(
    "password",
    mandatory: true,
    abbr: "p",
  );
  try {
    var results = parser.parse(args);
    String dbPath = "../models/users.db";
    Database db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('users');
    var bytes = utf8.encode(results['password']);
    var digest = sha256.convert(bytes);
    int key;
    await db.transaction((txn) async {
      key = await store.add(txn, {results['register']: digest.toString()});
    });
    print("User ${results["register"]} registered succesfully");
  } catch (e) {
    print("Error occoured: ${e}");
  }
}

void main(List<String> args) {
  registerUser(args);
}
