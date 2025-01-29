/* import 'package:flutter/material.dart';
import 'package:past_question_paper/features/core/Routes/routes.dart';
import 'package:past_question_paper/features/core/provider/quizprovider.dart';
import 'package:provider/provider.dart';

class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({super.key});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    // Fetch quiz results
    quizProvider.fetchQuizResults();

    final totalQuestions = quizProvider.questions.length;
    final correctAnswers = quizProvider.correctAnswersCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your Results',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You answered $correctAnswers out of $totalQuestions questions correctly!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                quizProvider.resetQuiz();
                Navigator.of(context)
                    .popAndPushNamed(RouteManager.quizScreenPage);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Text('Retake Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
 */