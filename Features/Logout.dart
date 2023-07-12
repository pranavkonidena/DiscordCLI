import 'FileHandling.dart';
import '../Parser.dart';

void Logout(var args) {
  var data = args[0].values.toList();
  data = data[0];
  var fileData = readFile("./loggedinUsers.txt");
  if (fileData.contains(data)) {
    deleteWord(data, "./loggedinUsers.txt");
    print("User logged out succesfully");
  } else {
    print("Please login before logging out");
  }
}
