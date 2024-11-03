import 'dart:io';
import 'class.dart';

Future<Quiz> createQuiz(User user) async {
  print("Enter quiz title:");
  String title = stdin.readLineSync()!;
  Quiz quiz = Quiz(title: title, creator: user);

  while (true) {
    print("Enter question text:");
    String questionText = stdin.readLineSync()!;

    print("Enter score for this question:");
    double score = double.parse(stdin.readLineSync()!);

    print("Enter question type (1 for Single Choice, 2 for Multichoice):");
    Type type =
        (stdin.readLineSync()! == '1') ? Type.SingleChoice : Type.Multichoice;

    List<String> options = [];
    print("Enter options (comma-separated):");
    options = stdin.readLineSync()!.split(',');

    if (type == Type.SingleChoice) {
      print("Enter the correct single choice answer:");
      String singleChoice = stdin.readLineSync()!;
      quiz.addQuestion(Question(
        questionText: questionText,
        type: type,
        Score: score,
        option: options,
        singleChoice: singleChoice,
      ));
    } else {
      print(
          "Enter the correct answers (comma-separated for multiple choices):");
      List<String> multiChoice = stdin.readLineSync()!.split(',');
      quiz.addQuestion(Question(
        questionText: questionText,
        type: type,
        Score: score,
        option: options,
        multiChoice: multiChoice,
      ));
    }

    print("Add another question? (y/n):");
    if (stdin.readLineSync()!.toLowerCase() != 'y') {
      break;
    }
  }
  return quiz;
}

Future<void> solveQuizMenu(List<Quiz> quizzes, User user) async {
  if (quizzes.isEmpty) {
    print("No quizzes available.");
    return;
  }

  print("Available Quizzes:");
  for (var quiz in quizzes) {
    print(
        "${quiz.title} by ${quiz.creator.firstName} ${quiz.creator.lastName}");
  }

  print("Please enter the title of the quiz you want to solve:");
  String quizTitle = stdin.readLineSync()!;

  Quiz? quizToSolve = quizzes.firstWhere((quiz) => quiz.title == quizTitle);

  Result result = await solveQuiz(quizToSolve);
  result.username = user.firstName + ' ' + user.lastName;
  result.displayResult();
}

Future<Result> solveQuiz(Quiz quiz) async {
  double totalScore = 0;
  List<Answer> answers = [];

  print("Solving quiz: ${quiz.title}");
  for (Question question in quiz.questions) {
    print("\n${question.questionText}");
    print("Options: ${question.option.join(', ')}");

    if (question.type == Type.SingleChoice) {
      print("Enter your answer:");
      String singleAnswer = stdin.readLineSync()!;
      answers.add(
          Answer(questionId: question.questionId, singleAnswer: singleAnswer));
    } else {
      print("Enter your answers (comma-separated):");
      List<String> multipleAnswer = stdin.readLineSync()!.split(',');
      answers.add(Answer(
          questionId: question.questionId, multipleAnswer: multipleAnswer));
    }
  }

  // Pass the entire list of answers to the Result object
  Result result = Result(answer: answers, username: '');
  result.checkAnswer(quiz.questions);
  return result;
}
