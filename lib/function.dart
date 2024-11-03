import 'class.dart';
import 'dart:io';

void inputQuestion() {
  stdout.write("Input Question ID: ");
  int? id = int.tryParse(stdin.readLineSync() ?? '');

  stdout.write("Input Question Text: ");
  String? text = stdin.readLineSync();

  stdout.write(
      "Input Question Type \"1\" = SingleChoice/ \"2\" = Multichoice ): ");
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
    if (answer != null) {
      singleChoice = answer;
    }
  } else if (Qtype == '2') {
    type = Type.Multichoice;
    stdout.write("Input Answers (comma-separated): ");
    String? answerInput = stdin.readLineSync();
    List<String> answers = answerInput?.split(',') ?? ["none"];

    if (answers.isNotEmpty) {
      multiChoice = answers;
    }
  }

  stdout.write("Input Options (comma-separated): ");
  String? optionInput = stdin.readLineSync();
  options = optionInput?.split(',') ?? [];

  // Creating the Question instance
  Question question = Question(
    questionId: id ?? 0,
    questionText: text ?? "Default Text",
    type: type ?? Type.SingleChoice,
    Score: score ?? 0.0,
    option: options,
    singleChoice: singleChoice,
    multiChoice: multiChoice,
  );
  Quiz quiz = Quiz(title: "hello");
  quiz.addQuestion(question);
  quiz.show();
}
