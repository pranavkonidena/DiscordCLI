import 'dart:io';

void main() {
  createFile("HI I am testing something!");
}

void createFile(var data) {
  try {
    String path = "./users.txt";
    File file = File(path);
    file.writeAsStringSync(data);
    print("File created successfully.");
  } catch (e) {
    print("Error occoured : ${e}");
  }
}

String readFile(String filePath) {
  File file = File(filePath);
  String data = file.readAsStringSync();
  return data;
}
