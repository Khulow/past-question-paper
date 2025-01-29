import 'package:flutter/material.dart';
import 'package:past_question_paper/models/question.dart';

class QuizReviewScreen extends StatelessWidget {
  final List<Question> questions;
  final Map<String, String> userAnswers;
  final VoidCallback onExitReview;

  const QuizReviewScreen({
    super.key,
    required this.questions,
    required this.userAnswers,
    required this.onExitReview,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Answers'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onExitReview,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final userAnswer = userAnswers[question.id];
          final isCorrect = userAnswer == question.correctAnswerId;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question number and status
                  Row(
                    children: [
                      Text(
                        'Question ${index + 1}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Question text
                  Text(
                    question.questionText,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  // Question image if available
                  if (question.imageUrl.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Image.network(
                      question.imageUrl,
                      errorBuilder: (context, error, stackTrace) =>
                          const Text('Image not available'),
                    ),
                  ],

                  const SizedBox(height: 16),
                  const Divider(),

                  // Answer options
                  ...question.answers.map((answer) {
                    final isSelected = userAnswer == answer.id;
                    final isCorrectAnswer =
                        question.correctAnswerId == answer.id;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: _getAnswerColor(isSelected, isCorrectAnswer),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getAnswerBorderColor(
                              isSelected, isCorrectAnswer),
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          answer.text,
                          style: TextStyle(
                            color: isSelected || isCorrectAnswer
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: Text(
                            answer.id,
                            style: TextStyle(
                              color:
                                  _getAnswerColor(isSelected, isCorrectAnswer),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  if (userAnswer != question.correctAnswerId) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Correct Answer: ${question.answers.firstWhere((a) => a.id == question.correctAnswerId).text}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getAnswerColor(bool isSelected, bool isCorrectAnswer) {
    if (isCorrectAnswer) return Colors.green;
    if (isSelected) return Colors.red;
    return Colors.white;
  }

  Color _getAnswerBorderColor(bool isSelected, bool isCorrectAnswer) {
    if (isCorrectAnswer) return Colors.green;
    if (isSelected) return Colors.red;
    return Colors.grey.shade300;
  }
}
