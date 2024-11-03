import 'dart:convert';
import 'dart:io';

class User {
  String firstName;
  String lastName;
  final String _username;
  final String _password;

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
  String title;
  User creator;
  List<Question> questions = [];

  Quiz({required this.title, required this.creator});

  void addQuestion(Question question) {
    questions.add(question);
  }

  Future<void> saveToFile(String filePath) async {
    final file = File(filePath);
    List<Quiz> quizzes = await loadQuizzes(filePath);
    quizzes.add(this);
    await file.writeAsString(
        jsonEncode(quizzes.map((quiz) => quiz.toJson()).toList()));
  }

  static Future<List<Quiz>> loadQuizzes(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      return (jsonDecode(jsonString) as List)
          .map((quizJson) => Quiz.fromJson(quizJson))
          .toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'creator': creator.toJson(),
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }

  static Quiz fromJson(Map<String, dynamic> json) {
    Quiz quiz = Quiz(
      title: json['title'],
      creator: User.fromJson(json['creator']),
    );
    for (var questionJson in json['questions']) {
      quiz.addQuestion(Question.fromJson(questionJson));
    }
    return quiz;
  }
}

class Answer {
  int questionId;
  String? singleAnswer;
  List<String>? multipleAnswer;

  Answer({required this.questionId, this.singleAnswer, this.multipleAnswer});
}

class Result {
  List<Answer> answer;
  String username;

  Result({required this.answer, required this.username});

  void checkAnswer(List<Question> questions) {
    double totalScore = 0;
    for (var answer in answer) {
      Question? question =
          questions.firstWhere((q) => q.questionId == answer.questionId);
      if (question.type == Type.SingleChoice &&
          answer.singleAnswer == question.singleChoice) {
        totalScore += question.Score;
      } else if (question.type == Type.Multichoice &&
          answer.multipleAnswer!
              .toSet()
              .containsAll(question.multiChoice!.toSet())) {
        totalScore += question.Score;
      }
    }
    print("Total score for $username: $totalScore");
  }

  void displayResult() {
    print("\nResults for $username:");
    for (var answer in answer) {
      print(
          "Question ID: ${answer.questionId}, Your answer: ${answer.singleAnswer ?? answer.multipleAnswer}");
    }
  }
}
