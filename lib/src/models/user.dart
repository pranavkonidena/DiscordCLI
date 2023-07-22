import 'dart:io';
import 'package:cryptography/cryptography.dart';
import 'package:discord_cli/src/cli/DM.dart';
import 'package:discord_cli/src/cli/dbFns/addtoDB.dart';
import 'package:discord_cli/src/cli/dbFns/equalFilter.dart';
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
import '../cli/dbFns/notNullFindRecord.dart';

class User {
  late String username;
  late List<String> servers;
  late List<String> channels;
  static List<User> instances = [];
  String role = "member";
  void logInUser(dynamic results) async {
    try {
      if (results['login'] == true) {
        String dbPath = "src/db/users.db";
        Database db = await databaseFactoryIo.openDatabase(dbPath);
        Database loggeddb =
            await databaseFactoryIo.openDatabase("src/db/servers_users.db");
        var store = intMapStoreFactory.store('users');
        var storelog = intMapStoreFactory.store("servers_users");
        var finder =
            Finder(filter: Filter.equals("username", results["username"]));
        var findRecord = await store.find(db, finder: finder);
        var finder_new = Finder(filter: Filter.notNull("username"));
        var finder_new_record = await notNullFindRecord(
            "src/db/servers_users.db", "servers_users", "username");
        if (finder_new_record.length == 0) {
          if (findRecord.isEmpty) {
            print("Please register before logging in");
          } else {
            var hashedPassword = findRecord[0].value.entries.last.value;
            var bytes = utf8.encode(results['password']);
            var digest = sha256.convert(bytes);
            if (digest.toString() == hashedPassword) {
              var findRecord = await equalQueryFindRecord(
                  "src/db/servers_users.db",
                  "servers_users",
                  "username",
                  results["username"]);
              if (findRecord.isEmpty) {
                loggedinUser user = loggedinUser();
                user.username = results['username'];
                dynamic data = {
                  "username": results['username'],
                  "servers": [],
                  "channels": [],
                };
                await addToDBTxn(
                    'src/db/servers_users.db', "servers_users", data);
                print("User ${results['username']} logged in succesfully");
                readDM();
                loggedinUser logUser = loggedinUser();
                logUser.username = results["username"];
              } else {
                print("User ${results["username"]} was already logged in!");
              }
            } else {
              print("Please enter the correct password");
            }
          }
        } else {
          if (finder_new_record[0].value["username"] == results["username"]) {
            print("User ${results["username"]} was already logged in!");
          } else {
            print(
                "You are logged in with ${finder_new_record[0].value["username"]}. Please log out first");
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
  String? access;
  joinServer(dynamic results) async {
    if (results['join'] == true) {
      String dbPath = "src/db/servers_users.db";
      String serverdbPath = "src/db/servers_channels.db";
      Database db = await databaseFactoryIo.openDatabase(dbPath);
      var store = intMapStoreFactory.store('servers_users');
      var finder =
          Finder(filter: Filter.equals("username", results["username"]));
      var findRecord = await equalQueryFindFirstRecord(
          dbPath, "servers_users", "username", results["username"]);
      if (findRecord == null) {
        print("Please login before joining a server");
      } else {
        var findRecord_server = await equalQueryFindRecord(
            serverdbPath, "servers_channels", "server", results["server"]);
        if (findRecord_server.isEmpty) {
          print("Please enter a valid server.");
        } else {
          dynamic map = cloneMap(findRecord.value);
          if (map["servers"].contains(results["server"])) {
            print(
                "User ${results['username']} has already joined the server ${results["server"]}");
          } else {
            List<dynamic> duplicates = [];
            duplicates = map["servers"];
            duplicates.add(results["server"]);
            map["servers"] = duplicates;
            try {
              await store.delete(db, finder: finder);
              await store.add(db, map);
            } catch (e) {
              await store.add(db, map);
            }

            int key;
            print(
                "User ${results["username"]} has joined the server ${results["server"]} successfully.");

            Database db_musers =
                await databaseFactoryIo.openDatabase("src/db/mod_users.db");
            var store_musers = intMapStoreFactory.store("users");
            var mUserRecord = await store_musers.findFirst(db_musers,
                finder: Finder(
                    filter: Filter.equals("username", results["username"])));
            if (mUserRecord != null) {
              dynamic map = cloneMap(mUserRecord.value);
              List<dynamic> duplicates = map["servers"];
              duplicates.add(results["server"]);
              map["servers"] = duplicates;
              await store_musers.delete(db_musers,
                  finder: Finder(
                      filter: Filter.equals("username", results["username"])));
              await store_musers.add(db_musers, map);
            }
          }
        }
      }
    } else {
      print("See docs");
    }
  }

  logout(dynamic results) async {
    if (results['logout'] == true) {
      try {
        Database dbU =
            await databaseFactoryIo.openDatabase("src/db/servers_users.db");
        var store1 = intMapStoreFactory.store('servers_users');
        var finder = Finder(filter: Filter.notNull("username"));
        User user = User();
        var record = await store1.find(dbU, finder: finder);
        if (record != null) {
          await store1.delete(dbU, finder: finder);
          print("User ${record[0].value["username"]} logged out succesfully.");
        } else {
          print("User was not logged in , can't log out");
        }
      } catch (e) {
        print("Can't logout as user was not logged in");
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
    var store1 = intMapStoreFactory.store("servers_users");
    var finder_new = Finder(filter: Filter.notNull("username"));
    var finder_new_record = await store1.find(dbU, finder: finder_new);
    var finder = Finder(filter: Filter.equals("username", recipient));
    var findRecord = await store.findFirst(db, finder: finder);
    if (findRecord == null) {
      print("The user ${results["recipient"]} is not registered");
    } else {
      dynamic map = cloneMap(findRecord.value);

      var entry = {
        "sender": finder_new_record[0].value["username"],
        "message": results["message"],
      };
      List<dynamic> duplicates = [];
      duplicates = map["messages"];
      duplicates.insert(0, entry);
      map["messages"] = duplicates;
      try {
        await store.delete(db, finder: finder);
        await store.add(db, map);
      } catch (e) {
        await store.add(db, map);
      }

      print("Message sent succesfully");
    }
  }

  void readDM() async {
    try {
      var findRecord = await notNullFindRecord(
          "src/db/servers_users.db", "servers_users", "username");
      if (findRecord.length != 0) {
        String dbPathMsg = "src/db/users.db";
        Database db_msg = await databaseFactoryIo.openDatabase(dbPathMsg);
        var store_msg = intMapStoreFactory.store("users");
        var finder_msg = Finder(
            filter: Filter.equals(
                "username", findRecord[0].value["username"].toString()));
        var msg_record = await store_msg.find(db_msg, finder: finder_msg);
        var seen_msg = await store_msg.findFirst(db_msg, finder: finder_msg);
        dynamic map = cloneMap(seen_msg!.value);
        map["messages"] = [];
        var list = msg_record[0].value["messages"] as List;
        print("You have a new message from ${(list[0] as Map)["sender"]}");
        print("The message is : ${(list[0] as Map)["message"]}");
        try {
          await store_msg.delete(db_msg, finder: finder_msg);
          await store_msg.add(db_msg, map);
        } catch (e) {
          await store_msg.add(db_msg, map);
        }
      }
    } catch (e) {}
  }

  void channelDM(dynamic results) async {
    var channel = results["channel"];
    var userRecord =
        await notNullFindRecord("src/db/users.db", "users", "username");
    List<dynamic> users = [];
    for (int i = 0; i < userRecord.length; i++) {
      List<dynamic> temp = userRecord[i].value["channels"] as List;
      if (temp.contains(results["channel"])) {
        users.add(userRecord[i].value["username"]);
      }
    }
    if (users.length == 0) {
      print("Invalid channel");
    } else {
      addMsg(users, results["message"], results["channel"]);
    }
  }

  // Can't seperate db in thisp
  void addMsg(List<dynamic> users, var message, var channelName) async {
    String dbPath = "src/db/users.db";
    Database db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store("users");
    for (int i = 0; i < users.length; i++) {
      var user = users[i];
      var finder = Finder(filter: Filter.equals("username", user));
      var userRecord = await store.findFirst(db, finder: finder);
      dynamic map = cloneMap(userRecord!.value);
      List<dynamic> duplicates = [];
      duplicates = map["messages"];
      var entry = {
        "sender": "Channel ${channelName}",
        "message": message,
      };
      duplicates.add(entry);
      map["messages"] = duplicates;
      try {
        await store.delete(db, finder: finder);
        await store.add(db, map);
      } catch (e) {
        await store.add(db, map);
      }
    }
    print("Message sent in channel succesfully.");
  }
}

class modUser extends loggedinUser {
  void restrictedDM(dynamic results) async {
    var luserRecord = await notNullFindFirstRecord(
        "src/db/servers_users.db", "servers_users", "username");
    if (luserRecord == null) {
      print("User not logged in!");
    } else {
      var username = luserRecord.value["username"];
      var modUserRecord = await equalQueryFindFirstRecord(
          "src/db/mod_users.db", "users", "username", username);
      if (modUserRecord == null) {
        print("You don't have access for that action");
      } else {
        channelDM(results);
      }
    }
  }
}
