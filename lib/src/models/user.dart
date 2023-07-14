class User {
  late String username;
  late bool isLogin;
  late List<String> servers;
  late List<String> channels;

  User(String givenUsername) {
    username = givenUsername;
  }
}
