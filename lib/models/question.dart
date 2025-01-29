import 'package:past_question_paper/models/answer.dart';

class Question {
  final String id;
  final String questionText;
  final String imageUrl;
  final String correctAnswerId;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.questionText,
    required this.imageUrl,
    required this.correctAnswerId,
    required this.answers,
  });

  factory Question.fromFirestore(Map<String, dynamic> data, String id) {
    List<Answer> answers = [];
    if (data['answers'] != null) {
      answers = (data['answers'] as List)
          .map((answerData) => Answer.fromFirestore(answerData))
          .toList();
    }

    return Question(
      id: id,
      questionText: data['question'] ?? '',
      imageUrl: data['image_url'] ?? '',
      correctAnswerId: data['correct_answer'] ?? '',
      answers: answers,
    );
  }

  // Add a toMap method for consistency and possible future use
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': questionText,
      'image_url': imageUrl,
      'correct_answer': correctAnswerId,
      'answers': answers.map((answer) => answer.toMap()).toList(),
    };
  }

  // Add method to check if an answer is correct
  bool isAnswerCorrect(String answerId) {
    return answerId == correctAnswerId;
  }
}
