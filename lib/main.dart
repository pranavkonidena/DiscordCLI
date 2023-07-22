import 'dart:math';
import 'package:discord_cli/src/cli/createChannel.dart';
import 'package:discord_cli/src/cli/createServer.dart';
import 'package:discord_cli/src/models/servers.dart';
import 'src/cli/register.dart';
import 'src/cli/login.dart';
import 'src/cli/logout.dart';
import 'src/models/user.dart';
import 'src/cli/joinServer.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'src/cli/DM.dart';
import 'src/cli/channelDM.dart';
import 'src/cli/createCategory.dart';
import 'src/cli/printCategory.dart';
import 'src/cli/printModUser.dart';
void main(List<String> arguments) async {
  if (arguments.contains("-l") || arguments.contains("--login")) {
    await loginUser(arguments);
  } else if (arguments.contains("-r") || arguments.contains("--register")) {
    await registerUser(arguments);
  } else if (arguments.contains("--logout")) {
    await logoutUser(arguments);
  } else if (arguments.contains("--join") || arguments.contains("-j")) {
    try {
      addToDb(arguments);
    } catch (e) {
      print(e);
    }
  } else if (arguments.contains("--dm")) {
    await dm(arguments);
  } else if (arguments.contains("--channelDM")) {
    await channelDM(arguments);
    // print("Hi");
  } else if (arguments.contains("--channel")) {
    await createChannel(arguments);
  } else if (arguments.contains("--server") &&
      !arguments.contains("--category") && !arguments.contains("--print")) {
    await createServer(arguments);
  } else if (arguments.contains("--category") && !arguments.contains("--print")) {
    await createCat(arguments);
  } else if (arguments.contains("--print") && arguments.contains("--category")) {
    await printCategory(arguments);
  } else if (arguments.contains("--print") && arguments.contains("--mU")){
    await printModUser(arguments);
  }
}
