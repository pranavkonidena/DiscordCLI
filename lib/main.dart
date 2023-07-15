import 'dart:math';
import 'package:discord_cli/src/models/servers.dart';
import './src/cli/register.dart';
import './src/cli/login.dart';
import './src/cli/logout.dart';
import './src/models/user.dart';
import './src/cli/joinServer.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';

void main(List<String> arguments) {
  if (arguments.contains("-l") || arguments.contains("--login")) {
    loginUser(arguments);
  }
  if (arguments.contains("-r") || arguments.contains("--register")) {
    registerUser(arguments);
  }
  if (arguments.contains("--logout")) {
    logoutUser(arguments);
  }
  if (arguments.contains("--join") || arguments.contains("-j")) {
    try {
      addToDb(arguments);
    } catch (e) {
      print(e);
    }

  }
}
