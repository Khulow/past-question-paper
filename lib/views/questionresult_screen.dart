import 'package:flutter/material.dart';
import 'package:past_question_paper/models/question.dart';
import 'package:past_question_paper/viewmodels/question_viewmodel.dart';
import 'package:past_question_paper/views/review_screen.dart';
import 'package:provider/provider.dart';

class QuizResultsScreen extends StatelessWidget {
  final List<Question> questions;
  final Map<String, String> userAnswers;
  final int timeSpent;
  final VoidCallback onReviewTap;
  final VoidCallback onRetryTap;
  final VoidCallback onExitTap;

  const QuizResultsScreen({
    super.key,
    required this.questions,
    required this.userAnswers,
    required this.timeSpent,
    required this.onReviewTap,
    required this.onRetryTap,
    required this.onExitTap,
  });

  int get totalQuestions => questions.length;

  int get correctAnswers {
    return questions
        .where((q) => userAnswers[q.id] == q.correctAnswerId)
        .length;
  }

  double get percentage => (correctAnswers / totalQuestions) * 100;

  String get grade {
    switch (percentage ~/ 10) {
      case 10:
      case 9:
        return 'A';
      case 8:
        return 'B';
      case 7:
        return 'C';
      case 6:
        return 'D';
      default:
        return 'F';
    }
  }

  String get formattedTime {
    final minutes = timeSpent ~/ 60;
    final seconds = timeSpent % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _handleRetry(BuildContext context) {
    // Get the QuestionViewModel
    final questionViewModel = context.read<QuestionViewModel>();

    // First stop any existing timer
    questionViewModel.stopTimer();

    // Reset all quiz state (this includes setting _remainingTime back to 600)
    questionViewModel.resetQuiz();

    // Now we can safely start a new quiz
    onRetryTap();
  }

  void _handleExit(BuildContext context) {
    // Get the QuestionViewModel
    final questionViewModel = context.read<QuestionViewModel>();

    // Stop the timer
    questionViewModel.stopTimer();

    // Reset quiz state
    questionViewModel.resetQuiz();

    // Exit the quiz
    onExitTap();
  }

  void _handleReview(BuildContext context) {
    // Get the QuestionViewModel
    final questionViewModel = context.read<QuestionViewModel>();

    // Stop the timer
    questionViewModel.stopTimer();

    // Navigate to the review screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizReviewScreen(
          questions: questions,
          userAnswers: userAnswers,
          onExitReview: () {
            Navigator.pop(context);
            onReviewTap();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Score Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Grade: $grade',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Statistics Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    _buildStatRow('Total Questions', totalQuestions.toString()),
                    _buildStatRow('Correct Answers', correctAnswers.toString()),
                    _buildStatRow('Incorrect Answers',
                        (totalQuestions - correctAnswers).toString()),
                    _buildStatRow('Time Spent', formattedTime),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            ElevatedButton.icon(
              onPressed: () => _handleReview(context),
              icon: const Icon(Icons.rate_review),
              label: const Text('Review Answers'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: () => _handleRetry(context),
              icon: const Icon(Icons.replay),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 8),

            OutlinedButton.icon(
              onPressed: () => _handleExit(context),
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Exit Quiz'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
