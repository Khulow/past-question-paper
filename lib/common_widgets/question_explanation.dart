import 'package:flutter/material.dart';
import 'package:past_question_paper/models/question.dart';

class QuestionExplanationDialog extends StatelessWidget {
  final Question question;
  final String selectedAnswerId;
  final VoidCallback onNext;

  const QuestionExplanationDialog({
    super.key,
    required this.question,
    required this.selectedAnswerId,
    required this.onNext,
  });

  bool get isCorrect => selectedAnswerId == question.correctAnswerId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Result Icon and Text
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 8),
                Text(
                  isCorrect ? 'Correct!' : 'Incorrect',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Question Text
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 16),

            // Your Answer
            Text(
              'Your Answer:',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                question.answers
                    .firstWhere((a) => a.id == selectedAnswerId)
                    .text,
              ),
            ),

            if (!isCorrect) ...[
              const SizedBox(height: 16),
              // Correct Answer
              Text(
                'Correct Answer:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  question.answers
                      .firstWhere((a) => a.id == question.correctAnswerId)
                      .text,
                ),
              ),
            ],

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onNext();
              },
              child: const Text('Next Question'),
            ),
          ],
        ),
      ),
    );
  }
}
