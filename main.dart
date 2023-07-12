import "Features/Register.dart";
import 'Parser.dart';
import 'Features/Login.dart';

void main(List<String> arguments) {
  var args_register = parser(arguments, "register", 1);
  var args_login = parser(arguments, "login", 1);
  if (arguments.contains("--register") && arguments.contains("--login")) {
    RegisterUser(args_register, 1);
    Login(args_login, 1);
  } else if (arguments.contains("--login")) {
    Login(args_login, 1);
  } else if (arguments.contains("--register")) {
    RegisterUser(args_register, 1);
  }
}
