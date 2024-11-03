import 'dart:convert';
import 'dart:io';

class User {
  String firstName;
  String lastName;
  String _username;
  String _password;

  User(this.firstName, this.lastName,
      {required String username, required String password})
      : _username = username,
        _password = password;

  String get username => _username;

  Future<void> saveToFile(String filePath) async {
    final file = File(filePath);
    List<User> users = await loadUsers(filePath);
    users.add(this);
    await file
        .writeAsString(jsonEncode(users.map((user) => user.toJson()).toList()));
  }

  static Future<List<User>> loadUsers(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      return (jsonDecode(jsonString) as List)
          .map((userJson) => User.fromJson(userJson))
          .toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': _username,
      'password': _password,
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      json['firstName'],
      json['lastName'],
      username: json['username'],
      password: json['password'],
    );
  }

  bool login(String username, String password) {
    return username == _username && password == _password;
  }
}

enum Type { SingleChoice, Multichoice }

class Question {
  static int _idCounter = 0;

  int questionId;
  String questionText;
  double Score;
  Type type;
  List<String> option;
  String? singleChoice;
  List<String>? multiChoice;

  Question({
    required this.questionText,
    required this.type,
    required this.Score,
    required this.option,
    this.singleChoice,
    this.multiChoice,
  }) : questionId = ++_idCounter;

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'Score': Score,
      'type': type.toString(),
      'option': option,
      'singleChoice': singleChoice,
      'multiChoice': multiChoice,
    };
  }

  static Question fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['questionText'],
      type: Type.values.firstWhere((e) => e.toString() == json['type']),
      Score: json['Score'],
      option: List<String>.from(json['option']),
      singleChoice: json['singleChoice'],
      multiChoice: json['multiChoice'] != null
          ? List<String>.from(json['multiChoice'])
          : null,
    );
  }
}

class Quiz {
  List<Question> questions = [];
  String title;

  Quiz({required this.title});

  void addQuestion(Question newQuestion) {
    questions.add(newQuestion);
  }

  void show() {
    print("Quiz Name: $title\n");
    for (var question in questions) {
      if (question.type == Type.SingleChoice) {
        print(
            "Question ID: ${question.questionId} \nText: ${question.questionText} \nType: ${question.type} \nScore: ${question.Score} \nCorrect Answer: ${question.singleChoice} \nOptions: ${question.option}");
      } else if (question.type == Type.Multichoice) {
        print(
            "Question ID: ${question.questionId} \nText: ${question.questionText} \nType: ${question.type} \nScore: ${question.Score} \nCorrect Answers: ${question.multiChoice} \nOptions: ${question.option}");
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }

  static Quiz fromJson(Map<String, dynamic> json) {
    Quiz quiz = Quiz(title: json['title']);
    quiz.questions =
        (json['questions'] as List).map((q) => Question.fromJson(q)).toList();
    return quiz;
  }
}

class Answer {
  int questionId;
  String? singleAnswer;
  List<String>? multipleAnswer;

  Answer({
    required this.questionId,
    this.singleAnswer,
    this.multipleAnswer,
  });
}

// Result Class
class Result {
  double score = 0;
  Answer answer;
  String username;

  Result({required this.answer, required this.username});

  void checkAnswer(List<Question> questions) {
    for (var question in questions) {
      if (answer.questionId == question.questionId) {
        if (question.type == Type.SingleChoice &&
            answer.singleAnswer == question.singleChoice) {
          score += question.Score;
          print("Correct Answer for Question ID: ${question.questionId}");
        } else if (question.type == Type.Multichoice &&
            answer.multipleAnswer != null &&
            compareAnswers(answer.multipleAnswer!, question.multiChoice!)) {
          score += question.Score;
          print("Correct Answer for Question ID: ${question.questionId}");
        } else {
          print(
              "Incorrect Question ${answer.questionId} answer is ${question.singleChoice}");
        }
      }
    }
  }

  bool compareAnswers(List<String> userAnswers, List<String> correctAnswers) {
    return Set.from(userAnswers).containsAll(correctAnswers) &&
        userAnswers.length == correctAnswers.length;
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'answer': {
        'questionId': answer.questionId,
        'singleAnswer': answer.singleAnswer,
        'multipleAnswer': answer.multipleAnswer,
      },
      'username': username,
    };
  }

  static Result fromJson(Map<String, dynamic> json) {
    return Result(
      answer: Answer(
        questionId: json['answer']['questionId'],
        singleAnswer: json['answer']['singleAnswer'],
        multipleAnswer: json['answer']['multipleAnswer'] != null
            ? List<String>.from(json['answer']['multipleAnswer'])
            : null,
      ),
      username: json['username'],
    );
  }

  void displayResult() {
    print("Username: $username, Score: $score");
  }
}

// Total Class
class Total {
  List<Result> results;

  Total(this.results);

  void calculateTotalScore() {
    double totalScore = results.fold(0, (sum, result) => sum + result.score);
    print("Total Score: $totalScore");
  }
}
