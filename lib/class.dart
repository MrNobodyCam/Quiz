class User {
  String firstName;
  String lastName;
  String _username;
  String _password;
  User(this.firstName, this.lastName,
      {required String username, required String password})
      : _username = username,
        _password = password;

  get username => _username;
  get password => _password;

  bool login(String newUsername, String newPassword) {
    if (newUsername != username || newPassword != password) {
      return false;
    } else {
      return true;
    }
  }

  void logout() {}
}

enum Type { SingleChoice, Multichoice }

class Question {
  int questionId;
  String questionText;
  double Score;
  Type type;
  List<String> option = [];
  String? singleChoice;
  List<String>? multiChoice = [];
  Question(
      {required this.questionId,
      required this.questionText,
      required this.type,
      required this.Score,
      required this.option,
      this.singleChoice,
      this.multiChoice});
}

class Quiz {
  List<Question> question = [];
  String title;
  Quiz({required this.title});
  void addQuestion(Question newQuestion) {
    this.question.add(newQuestion);
  }

  void show() {
    print("Quiz Name :  ${title} : \n");
    for (var questions in question) {
      if (questions.type == Type.SingleChoice) {
        print(
            "Question ID is ${questions.questionId} \n Text is ${questions.questionText} \n Type is ${questions.type} \n Score is ${questions.Score} \n Correct Answer is ${questions.singleChoice} \n Option are ${questions.option}");
      } else if (questions.type == Type.Multichoice) {
        print(
            "Question ID is ${questions.questionId} \n Text is ${questions.questionText} \n Type is ${questions.type} \n Score is ${questions.Score} \n Correct Answer is ${questions.multiChoice} \n Option are ${questions.option}");
      }
    }
  }
}

class Result {
  int scores;
  User user;
  Quiz quiz;
  Result({required this.scores, required this.user, required this.quiz});
}

// void main() {
//   // User user =
//   //     User("firstName", "lastName", username: "admin", password: "password");
//   // print("Username is ${user.username} , Password is ${user.password}");
//   // print(user.login("adsmin", "Passsword"));

//   Question question1 = Question(
//       questionId: 1,
//       questionText: "questionText1",
//       type: Type.SingleChoice,
//       Score: 5,
//       singleChoice: "correctAnswer",
//       option: ["hello1", "hi1"]);

//   Question question2 = Question(
//       questionId: 2,
//       questionText: "questionText2",
//       type: Type.Multichoice,
//       Score: 15,
//       multiChoice: ["correctAnswer1", "correctAnswer2"],
//       option: ["hello1", "hi1"]);

//   // Question question2 = Question(
//   //     questionId: 2, questionText: "questionText2", option: ["hello2", "hi2"]);
//   Quiz quiz = Quiz(title: "hello");
//   quiz.addQuestion(question1);
//   quiz.addQuestion(question2);
//   // quiz.addQuestion(question2);
//   quiz.show();
// }
