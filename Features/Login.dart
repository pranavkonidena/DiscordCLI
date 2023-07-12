import '../Parser.dart';
import './FileHandling.dart';

void main(List<String> arguments) {}

bool Login(var args, int NumberOfUsers) {
  try {
    String fileData = readFile("./registeredUsers.txt");
    for (int i = 0; i < NumberOfUsers; i++) {
      var data = args[i].values.toList();
      if (fileData.contains(data[i])) {
        try {
          appendToFile(' ' + data[i], "./loggedinUsers.txt");
        } catch (e) {
          createFile(data[i] , "./loggedinUsers.txt");
        }
        print("User ${data[i]} logged in succesfully.");
        return true;
      } else {
        print("Please register before logging in!");
        return false;
      }
    }
  } catch (e) {
    print("Please register before logging in!");
    return false;
  }
  return false;
}
