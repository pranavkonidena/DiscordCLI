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
  User user = User();
  user.username = results["username"];
  user.logInUser(results);
}

void main(List<String> args) {
  loginUser(args);
}
