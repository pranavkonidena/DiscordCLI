import 'package:discord_cli/src/models/user.dart';

class Server {
  List<String> serverUsers = [];
  List<String> channels = [];
  late String serverName;
}

class Channel extends Server {
  List<String> channelUsers = [];
  late String channelName;
  late String channelCategory;

  Channel(String channel_name, String Category) {
    channelName = channel_name;
    channelCategory = Category;
  }

  createChannel(dynamic user, dynamic category) {
    channelUsers.add(user);
    print("User joined channel succesfully.");
    channelCategory = category;
  }
}
