import 'dart:io';
import 'function.dart';

void main() {
  print(
      "========================== Welcome To Best of The Best Quiz Application ==========================");

  String? input;
  do {
    print("1. Register");
    print("2. Login");
    stdout.write("Input (1,2): ");
    input = stdin.readLineSync();

    if (input != "1" && input != "2") {
      print("Invalid option. Please enter '1' for Register or '2' for Login.");
    }
  } while (input != "1" && input != "2");

  switch (input) {
    case "1":
      {
        registerUser();
        print("Please Login Your Account : ");
        loginUser();
        break;
      }
    case "2":
      {
        loginUser();
        break;
      }
  }
}
