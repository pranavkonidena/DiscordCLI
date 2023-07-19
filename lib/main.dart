import 'dart:math';
import 'package:discord_cli/src/cli/createChannel.dart';
import 'package:discord_cli/src/cli/createServer.dart';
import 'package:discord_cli/src/models/servers.dart';
import './src/cli/register.dart';
import './src/cli/login.dart';
import './src/cli/logout.dart';
import './src/models/user.dart';
import './src/cli/joinServer.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import './src/cli/DM.dart';
import './src/cli/channelDM.dart';
import './src/cli/createCategory.dart';

void main(List<String> arguments) {
  if (arguments.contains("-l") || arguments.contains("--login")) {
    loginUser(arguments);
  } else if (arguments.contains("-r") || arguments.contains("--register")) {
    registerUser(arguments);
  } else if (arguments.contains("--logout")) {
    logoutUser(arguments);
  } else if (arguments.contains("--join") || arguments.contains("-j")) {
    try {
      addToDb(arguments);
    } catch (e) {
      print(e);
    }
  } else if (arguments.contains("--dm")) {
    dm(arguments);
  } else if (arguments.contains("--channelDM")) {
    channelDM(arguments);
    // print("Hi");
  } else if (arguments.contains("--channel")) {
    createChannel(arguments);
  } else if (arguments.contains("--server") && !arguments.contains("--category")) {
    createServer(arguments);
  } else if (arguments.contains("--category")) {
    createCat(arguments);
  }
}

// Channel locking basically will be smtg like add an atribute to the user , and save it to a databse and 
// check if the attribute is mod finally.

