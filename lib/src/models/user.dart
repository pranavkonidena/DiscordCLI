import 'servers.dart';
import '../cli/joinServer.dart';
import '../cli/login.dart';
import '../cli/register.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:sembast/utils/value_utils.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  late String username;
  late List<String> servers;
  late List<String> channels;
  static List<User> instances = [];

  dynamic logInUser(dynamic results) async {
    try {
      if (results['login'] == true) {
        String dbPath = "src/db/users.db";
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
            String dbPath = "src/db/servers_users.db";
            Database db = await databaseFactoryIo.openDatabase(dbPath);
            var store = intMapStoreFactory.store('servers_users');
            var finder =
                Finder(filter: Filter.equals("username", results["username"]));
            var findRecord = await store.find(db, finder: finder);
            if (findRecord.isEmpty) {
              loggedinUser user = loggedinUser();
              user.username = results['username'];

              int key;
              await db.transaction((txn) async {
                key = await store.add(txn, {
                  "username": results['username'],
                  "servers": [],
                });
              });
              print("User ${results['username']} logged in succesfully");
              loggedinUser logUser = loggedinUser();
              logUser.username = results["username"];
              return logUser;
            } else {
              print("User ${results["username"]} was already logged in!");
            }
          } else {
            print("Please enter the correct password");
          }
        }
      } else {
        print("Read docs");
      }
    } catch (e) {
      print(e);
    }
  }
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

  joinServer(dynamic results) async {
    if (results['join'] == true) {
      String dbPath = "src/db/servers_users.db";
      Database db = await databaseFactoryIo.openDatabase(dbPath);
      var store = intMapStoreFactory.store('servers_users');
      int key;
      var finder =
          Finder(filter: Filter.equals("username", results["username"]));
      var findRecord = await store.findFirst(db, finder: finder);
      if (findRecord == null) {
        print("Please login before joining a server");
      } else {
        // findRecord[0].value.entries.last.value returns list of servers of a particular username.
        // findRecord[0].value.entries.last.value.add(results["server"]);
        dynamic map = cloneMap(findRecord.value);
        if (map["servers"].contains(results["server"])) {
          print(
              "User ${results['username']} has already joined the server ${results["server"]}");
        } else {
          await store.delete(db, finder: finder);
          List<dynamic> duplicates = [];
          duplicates = map["servers"];
          duplicates.add(results["server"]);
          map["servers"] = duplicates;
          await store.add(db, map);
          print(
              "User ${results["username"]} has joined the server ${results["server"]} successfully.");
        }
      }
    } else {
      print("See docs");
    }
  }

  logout(dynamic results) async {
    if (results['logout'] == true) {
      try {
        String dbPath = "src/db/users.db";
        Database db = await databaseFactoryIo.openDatabase(dbPath);
        Database dbU =
            await databaseFactoryIo.openDatabase("src/db/servers_users.db");
        var store = intMapStoreFactory.store('users');
        var store1 = intMapStoreFactory.store('servers_users');
        var finder =
            Finder(filter: Filter.equals("username", results["username"]));
        var findRecord = await store.find(db, finder: finder);
        if (findRecord.isEmpty) {
          print("User not found. Please register before logging out.");
        } else {
          User user = User();
          user.username = results['username'];
          var record = await store1.find(dbU, finder: finder);
          await store1.delete(dbU, finder: finder);
          print("User ${user.username} logged out succesfully.");
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("Read docs");
    }
  }

  sendDM(dynamic results) async {
    var recipient = results["recipient"];
    String dbPath = "src/db/users.db";
    Database db = await databaseFactoryIo.openDatabase(dbPath);
    Database dbU =
        await databaseFactoryIo.openDatabase("src/db/servers_users.db");
    var store = intMapStoreFactory.store('users');
    var finder = Finder(filter: Filter.equals("username", recipient));
    var findRecord = await store.findFirst(db, finder: finder);
    if (findRecord == null) {
      print("The user ${results["recipient"]} is not registered");
    } else {
      dynamic map = cloneMap(findRecord.value);
      await store.delete(db, finder: finder);
      List<dynamic> duplicates = [];
      duplicates = map["messages"];
      duplicates.add(results["message"]);
      map["messages"] = duplicates;
      await store.add(db, map);
      print("Message sent succesfully");
    }
  }
}
