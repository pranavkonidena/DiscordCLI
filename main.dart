import "Features/Register.dart";
import 'Parser.dart';

void main(List<String> arguments) {
  var args = parser(arguments, "register", 1);
  RegisterUser(args, 1);
}
