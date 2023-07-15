import 'servers.dart';
import '../cli/joinServer.dart';
import '../cli/login.dart';

class User {
  late String username;
  late List<String> servers;
  late List<String> channels;
  static List<User> instances = [];
}

class loggedinUser extends User {
  late String role = "";
  sendMessage() {
    if (role == "mod") {
      print("Only logged in Users can call this method.");
    } else {
      print("U dont have access for that.");
    }
  }

  joinServer(List<String> arguments, loggedinUser user) {
    addToDb(arguments);
  }
}
