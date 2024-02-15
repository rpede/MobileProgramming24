/// Data class for a question.
class Question {
  /// The question text.
  /// 
  /// Example: What is Dart?
  final String text;
  /// Options that can be chosen from to answer the question.
  /// 
  /// Example: ["Programming language", "Airborne ranged weapon"]
  final List<String> options;
  /// Which of the options is the correct answer.
  final String correct;
  /// Which of the options the user picked as their answer.
  String? answered;

  Question(this.text,
      {required this.options, required this.correct, this.answered});
}

/// A quiz is just a list of questions.
/// 
/// The `typedef` keyword means that `Quiz` becomes an alias for
/// `List<Question>`.
typedef Quiz = List<Question>;
