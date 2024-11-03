import 'dart:convert';
import 'dart:io';
import 'class.dart';

const String userDataFilePath = 'users.json';
const String quizDataFilePath = 'quiz.json';
const String resultDataFilePath = 'results.json';

void main() async {
  while (true) {
    print('Welcome to the Quiz Application!');
    print('1. Sign Up');
    print('2. Log In');
    print('3. Exit');
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        await signUp();
        break;
      case '2':
        await logIn();
        break;
      case '3':
        print('Exiting the application.');
        return;
      default:
        print('Invalid option. Please choose again.');
    }
  }
}

Future<void> signUp() async {
  print('--- Sign Up ---');
  print('Enter your Firstname:');
  String firstName = stdin.readLineSync() ?? '';
  print('Enter your Lastname:');
  String lastName = stdin.readLineSync() ?? '';
  print('Enter a Username:');
  String username = stdin.readLineSync() ?? '';
  print('Enter a Password:');
  String password = stdin.readLineSync() ?? '';

  User newUser =
      User(firstName, lastName, username: username, password: password);
  await newUser.saveToFile(userDataFilePath);
  print('User registered successfully!\n');
}

Future<void> logIn() async {
  print('--- Log In ---');
  print('Enter your username:');
  String username = stdin.readLineSync() ?? '';
  print('Enter your password:');
  String password = stdin.readLineSync() ?? '';

  List<User> users = await User.loadUsers(userDataFilePath);
  User? loggedInUser;

  for (var user in users) {
    if (user.login(username, password)) {
      loggedInUser = user;
      break;
    }
  }

  if (loggedInUser != null) {
    print(
        'Login successful! Welcome, ${loggedInUser.firstName} ${loggedInUser.lastName}.\n');
    await takeQuiz(loggedInUser.username);
  } else {
    print('Login failed! Please check your username and password.\n');
  }
}

Future<void> takeQuiz(String username) async {
  Quiz? quiz = await loadQuizFromFile(quizDataFilePath);
  if (quiz == null) {
    print('No quiz available. Please add a quiz first.');
    return;
  }

  print('--- Quiz: ${quiz.title} ---');
  double totalScore = 0;

  for (var question in quiz.questions) {
    print('Question ID: ${question.questionId}');
    print('Question: ${question.questionText}');
    print('Options:');
    for (var option in question.option) {
      print(option);
    }

    print('Your answer:');
    String? answer = stdin.readLineSync();

    if (question.type == Type.SingleChoice) {
      if (answer == question.singleChoice) {
        totalScore += question.Score;
      }
    } else if (question.type == Type.Multichoice) {
      List<String> answers = answer?.split(',') ?? [];
      if (compareAnswers(answers, question.multiChoice!)) {
        totalScore += question.Score;
      }
    }
  }

  Result result = Result(answer: Answer(questionId: 0), username: username);
  result.score = totalScore;
  await saveResultToFile(result, resultDataFilePath);
  result.displayResult();
}

bool compareAnswers(List<String> userAnswers, List<String> correctAnswers) {
  return Set.from(userAnswers).containsAll(correctAnswers) &&
      userAnswers.length == correctAnswers.length;
}

Future<void> saveQuizToFile(Quiz quiz, String filePath) async {
  final file = File(filePath);
  await file.writeAsString(jsonEncode(quiz.toJson()));
  print('Quiz saved to file: $filePath');
}

Future<Quiz?> loadQuizFromFile(String filePath) async {
  final file = File(filePath);
  if (await file.exists()) {
    final jsonString = await file.readAsString();
    return Quiz.fromJson(jsonDecode(jsonString));
  } else {
    print('File not found: $filePath');
    return null;
  }
}

Future<void> saveResultToFile(Result result, String filePath) async {
  final file = File(filePath);
  var results = [];

  if (await file.exists()) {
    final jsonString = await file.readAsString();
    results = jsonDecode(jsonString);
  }

  results.add(result.toJson());
  await file.writeAsString(jsonEncode(results));
  print('Results saved to file: $filePath');
}

Future<List<Result>> loadResultsFromFile(String filePath) async {
  final file = File(filePath);
  if (await file.exists()) {
    final jsonString = await file.readAsString();
    return (jsonDecode(jsonString) as List)
        .map((resultJson) => Result.fromJson(resultJson))
        .toList();
  } else {
    print('File not found: $filePath');
    return [];
  }
}
