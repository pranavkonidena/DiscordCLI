class Server {
  List<String> users = [];
  List<String> channels = [];
  late String serverName;

  Server(given_server) {
    serverName = given_server;
  }
}
