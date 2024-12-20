class User {
  String firstName;
  String lastName;
  String _username;
  String _password;
  User(
      {required this.firstName,
      required this.lastName,
      required String username,
      required String password})
      : _username = username,
        _password = password;

  get username => _username;
  get password => _password;

  // bool login(String newUsername, String newPassword) {
  //   return newUsername == username && newPassword == password;
  // }
}

class Register {
  List<User> users = [];

  void addUser(User user) {
    users.add(user);
    print("User \"${user.username}\" has been registered successfully!");
  }
}

class Login {
  Register? registers;

  Login({this.registers});

  bool login(String newUsername, String newPassword) {
    if (registers != null) {
      for (var user in registers!.users) {
        if (newUsername == user.username && newPassword == user.password) {
          return true;
        }
      }
    }
    return false;
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
}

class Quiz {
  List<Question> questions = [];
  String title;

  Quiz({required this.title});

  void addQuestion(Question newQuestion) {
    questions.add(newQuestion);
  }

  void show() {
    print("Quiz Name :  $title : \n");
    for (var question in questions) {
      if (question.type == Type.SingleChoice) {
        print(
            "Question ID: ${question.questionId} \n Text: ${question.questionText} \n Type: ${question.type} \n Score: ${question.Score} \n Correct Answer: ${question.singleChoice} \n Options: ${question.option}");
      } else if (question.type == Type.Multichoice) {
        print(
            "Question ID: ${question.questionId} \n Text: ${question.questionText} \n Type: ${question.type} \n Score: ${question.Score} \n Correct Answers: ${question.multiChoice} \n Options: ${question.option}");
      }
    }
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

class Result {
  double score = 0;
  List<Answer> answers;

  Result({required this.answers});

  void checkAnswer(List<Question> questions) {
    for (var answer in answers) {
      for (var question in questions) {
        if (answer.questionId == question.questionId) {
          if (question.type == Type.SingleChoice &&
              answer.singleAnswer == question.singleChoice) {
            score += question.Score;
            print(
                "Correct Question: ${question.questionText} | Answer is \"${question.singleChoice}\"");
          } else if (question.type == Type.Multichoice &&
              answer.multipleAnswer != null &&
              compareAnswers(answer.multipleAnswer!, question.multiChoice!)) {
            score += question.Score;
            print(
                "Correct Question: ${question.questionText} | Answer is \"${question.multiChoice}\"");
          } else {
            print(
                "Incorrect Question: ${question.questionText} | Correct Answer: ${question.singleChoice}");
          }
        }
      }
    }
  }

  bool compareAnswers(List<String> userAnswers, List<String> correctAnswers) {
    return Set.from(userAnswers).containsAll(correctAnswers) &&
        userAnswers.length == correctAnswers.length;
  }
}

class Total {
  List<Result> results;

  Total(this.results);

  void calculateTotalScore() {
    double totalScore = results.fold(0, (sum, result) => sum + result.score);
    print("Total Score: $totalScore");
  }
}

// void main() {
//   // User user =
//   //     User("firstName", "lastName", username: "admin", password: "password");
//   // print("Username is ${user.username} , Password is ${user.password}");
//   // print(user.login("adsmin", "Passsword"));
//   Question question1 = Question(
//       questionText: "What is the capital of France?",
//       type: Type.SingleChoice,
//       Score: 5,
//       singleChoice: "Paris",
//       option: ["Paris", "London", "Berlin", "Madrid"]);

//   Question question2 = Question(
//       questionText: "Select fruits",
//       type: Type.Multichoice,
//       Score: 10,
//       multiChoice: ["Apple", "Banana"],
//       option: ["Apple", "Banana", "Carrot", "Onion"]);

//   Quiz quiz = Quiz(title: "Geography and Food Quiz");
//   quiz.addQuestion(question1);
//   quiz.addQuestion(question2);

//   Answer answer1 =
//       Answer(questionId: question1.questionId, singleAnswer: "Paris");
//   Answer answer2 = Answer(
//       questionId: question2.questionId, multipleAnswer: ["Apple", "Banana"]);

//   Result result1 = Result(answer: answer1);
//   Result result2 = Result(answer: answer2);

//   result1.checkAnswer(quiz.questions);
//   result2.checkAnswer(quiz.questions);
//   Total total = Total([result1, result2]);
//   total.calculateTotalScore();
//   // quiz.show();
// }
