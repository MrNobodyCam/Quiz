import 'dart:io';
import 'class.dart';

Register register = Register();
Quiz? currentQuiz;
void createQuestion(Quiz quiz) {
  stdout.write("Input Question Text: ");
  String? text = stdin.readLineSync();

  stdout.write(
      "Input Question Type \"1\" = SingleChoice , \"2\" = Multichoice): ");
  String? Qtype = stdin.readLineSync();

  stdout.write("Input Question Score: ");
  double? score = double.tryParse(stdin.readLineSync() ?? '');

  Type? type;
  String? singleChoice;
  List<String>? multiChoice = [];
  List<String> options = [];

  if (Qtype == '1') {
    type = Type.SingleChoice;
    stdout.write("Input Answer: ");
    String? answer = stdin.readLineSync();
    if (answer != null) singleChoice = answer;
  } else if (Qtype == '2') {
    type = Type.Multichoice;
    stdout.write("Input Answers (comma-separated): ");
    String? answerInput = stdin.readLineSync();
    multiChoice = answerInput?.split(',') ?? [];
  }

  stdout.write("Input Options (comma-separated): ");
  String? optionInput = stdin.readLineSync();
  options = optionInput?.split(',') ?? [];

  Question question = Question(
    questionText: text ?? "Default Text",
    type: type ?? Type.SingleChoice,
    Score: score ?? 0.0,
    option: options,
    singleChoice: singleChoice,
    multiChoice: multiChoice,
  );

  quiz.addQuestion(question);
  print("Question added successfully.");
}

void createQuiz() {
  stdout.write("Input the Quiz Title: ");
  String? Qtitle = stdin.readLineSync();
  currentQuiz = Quiz(title: Qtitle ?? "Untitled Quiz");

  while (true) {
    stdout.write("Add a new question? (y/n): ");
    String? response = stdin.readLineSync();
    if (response?.toLowerCase() == 'y') {
      createQuestion(currentQuiz!);
    } else {
      break;
    }
  }
  print("\n--- Quiz Created Successfully ---\n");
}

void answerQuiz() {
  if (currentQuiz == null || currentQuiz!.questions.isEmpty) {
    print("No questions available in the quiz. Please create questions first.");
    return;
  }

  List<Answer> userAnswers = [];

  for (var question in currentQuiz!.questions) {
    print("\nQuestion ${question.questionId}: ${question.questionText}");
    print("Options: ${question.option.join(', ')}");

    if (question.type == Type.SingleChoice) {
      stdout.write("Enter your answer: ");
      String? answer = stdin.readLineSync();
      userAnswers.add(Answer(
        questionId: question.questionId,
        singleAnswer: answer,
      ));
    } else if (question.type == Type.Multichoice) {
      stdout.write("Enter your answers (comma-separated): ");
      String? input = stdin.readLineSync();
      List<String> answers = input?.split(',') ?? [];
      userAnswers.add(Answer(
        questionId: question.questionId,
        multipleAnswer: answers,
      ));
    }
  }
  print("\n--- Quiz Completed ---\n");
  Result result = Result(answers: userAnswers);
  result.checkAnswer(currentQuiz!.questions);
  Total total = Total([result]);
  total.calculateTotalScore();
  print("==========================================");
}

void registerUser() {
  stdout.write("Input First-Name: ");
  String? Rfirstname = stdin.readLineSync();
  stdout.write("Input Last-Name: ");
  String? Rlastname = stdin.readLineSync();
  stdout.write("Input Username: ");
  String? Rusername = stdin.readLineSync();
  stdout.write("Input Password: ");
  String? Rpassword = stdin.readLineSync();

  User user = User(
    firstName: Rfirstname ?? "none",
    lastName: Rlastname ?? "none",
    username: Rusername ?? "admin",
    password: Rpassword ?? "password",
  );

  register.addUser(user);
  print("User Registered Successfully.");
}

void loginUser() {
  stdout.write("Input Username: ");
  String? username = stdin.readLineSync();
  stdout.write("Input Password: ");
  String? password = stdin.readLineSync();
  Login login = Login(registers: register);

  if (login.login(username ?? "", password ?? "")) {
    print("Login Success");
    String? option;
    print("==========================================");
    do {
      print("1. Create Quiz");
      print("2. Solve Quiz");
      print("3. Exit");
      stdout.write("Select an option (1, 2, or 3): ");
      option = stdin.readLineSync();

      switch (option) {
        case "1":
          createQuiz();
          break;
        case "2":
          answerQuiz();
          break;
        case "3":
          print("Exiting...");
          break;
        default:
          print("Invalid Input. Please enter 1, 2, or 3.");
          break;
      }
    } while (option != "3");
  } else {
    print("Your Username or Password is Incorrect.");
  }
}
