List parser(List<String> arguments, String target, int NumberOfElements) {
  int target_index = 0;
  var results_parsed = [];
  for (int i = 0; i < arguments.length; i++) {
    if (arguments.elementAt(i).contains(target)) {
      target_index = i;
    }
  }
  var key_value = "";
  for (int l = target_index + 1; l <= target_index + NumberOfElements; l++) {
    key_value += arguments.elementAt(l);
    if(l < target_index + NumberOfElements){
      key_value += "_";
    }
   
  }

  var entry = {target: key_value};
  results_parsed.add(entry);
  return results_parsed;
}

void main(List<String> arguments) {
  var args_type = [];
  args_type = parser(arguments, "type", 2);
  var args_register = [];
  args_register = parser(arguments, "register", 1);
  print(args_type);
  print(args_register);
}
