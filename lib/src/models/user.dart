class User {
  late String username;
  late List<String> servers;
  late List<String> channels;
  static List<User> instances = [];
}

class loggedinUser extends User {
  sendMessage() {
    print("Only logged in Users can call this method.");
  }
}
