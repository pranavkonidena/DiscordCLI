import '../Parser.dart';
import "./FileHandling.dart";

void RegisterUser(List<String> users, var args, int NumberOfUsers) {
  var data = args[0].values.toList();
  for (int i = 0; i < NumberOfUsers; i++) {
    String filePath = "./users.txt";
    String fileData = readFile(filePath);
    if (fileData.contains(data[i])) {
      print("Failure");
      break;
    } else {
      createFile(data[i]);
      print("Success");
    }
  }
}

void main(List<String> arguments) {
  List register_args = parser(arguments, "register", 1);
  List<String> active_users = [];
  int Users_number = 1;
  RegisterUser(active_users, register_args, Users_number);
  print(active_users);
}
