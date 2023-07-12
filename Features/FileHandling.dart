import 'dart:io';

void main() {}

void createFile(var data, String path) {
  try {
    File file = File(path);
    file.writeAsStringSync(data);
  } catch (e) {
    print("Error occoured : ${e}");
  }
}

void appendToFile(var data, String filePath) async {
  var file = File(filePath);
  var stream = await file.openWrite(mode: FileMode.append);
  stream.write(data);
  // stream.close().then((_) {
  // }).catchError((error) {
  //   print(error);
  // });
}

String readFile(String filePath) {
  File file = File(filePath);
  String data = file.readAsStringSync();
  return data;
}

void deleteWord(String word, String filePath) {
  String data = readFile(filePath);
  data = data.replaceAll(word, '');
  var file = File(filePath);
  file.writeAsStringSync(data);
}
