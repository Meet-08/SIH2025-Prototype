enum QuestionType { multipleChoice, rating }

class QuestionModel {
  final String id;
  final String question;
  final QuestionType type;
  final List<String>? options;

  QuestionModel({
    required this.id,
    required this.question,
    required this.type,
    this.options,
  });
}
