import 'dart:async';
import 'package:args/args.dart';
import '../models/user.dart';


Future<void> loginUser(List<String> args) async {
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

  var results = parser.parse(args);
  User user = User();
  user.username = results["username"];
  user.logInUser(results);
}

void main(List<String> args) {
  loginUser(args);
}
