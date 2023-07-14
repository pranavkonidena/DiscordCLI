import './src/cli/register.dart';
import './src/cli/login.dart';
import './src/cli/logout.dart';

void main(List<String> arguments) {
  if (arguments.contains("-l")) {
    loginUser(arguments);
  }
  if (arguments.contains("-r")) {
    registerUser(arguments);
  }
  if (arguments.contains("--logout")) {
    logoutUser(arguments);
  }
}
