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

void appendToFile(var data , String filePath){
  var file = File(filePath);
  var stream = file.openWrite(mode: FileMode.append);
  stream.write(data);
  stream.close().then((_) {
  }).catchError((error) {
    print('An error occurred while appending the content: $error');
  });
}

String readFile(String filePath) {
  File file = File(filePath);
  String data = file.readAsStringSync();
  return data;
}
