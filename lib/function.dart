import 'dart:convert';
import 'dart:io';
import 'class.dart';

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
