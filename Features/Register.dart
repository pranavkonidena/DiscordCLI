import "./FileHandling.dart";


void RegisterUser(var args, int NumberOfUsers)  {
  var data = args[0].values.toList();
  for (int i = 0; i < NumberOfUsers; i++) {
    try {
      String filePath = "./registeredUsers.txt";
      String fileData = readFile(filePath);
      if (fileData.contains(data[i])) {
        print("Failure");
        break;
      } else {
        appendToFile(' ' + data[i], filePath);
        print("Success");
        break;
      }
    } catch (e) {
      createFile(data[i] , "./registeredUsers.txt");
      print("Success");
    }
  }
}

void main(List<String> arguments) {}
