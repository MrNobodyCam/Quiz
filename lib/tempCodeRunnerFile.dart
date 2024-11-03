import 'dart:io';
import 'class.dart';
import 'function.dart';

void main() async {
  const String userFilePath = 'users.json';
  const String quizFilePath = 'quizzes.json';
  List<User> users = await User.loadUsers(userFilePath); // Load existing users
  List<Quiz> quizzes =
      await Quiz.loadQuizzes(quizFilePath); // Load existing quizzes

  while (true) {
    print("\nWelcome to the Quiz App!");
    print("1. Sign Up");
    print("2. Log In");
    print("3. Exit");
    print("Choose an option:");

    String choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        // Sign Up
        await signUp(users, userFilePath);
        break;

      case '2':
        // Log In
        await logIn(users, quizzes, quizFilePath);
        break;

      case '3':
        print("Goodbye!");
        return;

      default:
        print("Invalid option, please try again.");
    }
  }
}

Future<void> signUp(List<User> users, String filePath) async {
  print("Enter your first name:");
  String firstName = stdin.readLineSync()!;
  print("Enter your last name:");
  String lastName = stdin.readLineSync()!;
  print("Enter a username:");
  String username = stdin.readLineSync()!;
  print("Enter a password:");
  String password = stdin.readLineSync()!;

  User newUser =
      User(firstName, lastName, username: username, password: password);
  await newUser.saveToFile(filePath);
  users.add(newUser);
  print("Sign up successful! You can now log in.");
}

Future<void> logIn(
    List<User> users, List<Quiz> quizzes, String quizFilePath) async {
  print("Enter your username:");
  String username = stdin.readLineSync()!;
  print("Enter your password:");
  String password = stdin.readLineSync()!;

  User? loggedInUser =
      users.firstWhere((user) => user.login(username, password));

  print("Login successful! Welcome, ${loggedInUser.firstName}.");
  await userMenu(loggedInUser, quizzes, quizFilePath);
}

Future<void> userMenu(
    User user, List<Quiz> quizzes, String quizFilePath) async {
  while (true) {
    print("\nUser Menu:");
    print("1. Create a Quiz");
    print("2. Solve a Quiz");
    print("3. Exit to Main Menu");
    String choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        // Create a Quiz
        Quiz quiz = await createQuiz(user);
        quizzes.add(quiz);
        await quiz.saveToFile(quizFilePath);
        print("Quiz created successfully!");
        break;

      case '2':
        // Solve a Quiz
        await solveQuizMenu(quizzes, user);
        break;

      case '3':
        return;

      default:
        print("Invalid option, please try again.");
    }
  }
}
