import 'package:flutter/material.dart';
import 'package:past_question_paper/Routes/routes.dart';
import 'package:past_question_paper/services/navigation_service.dart';
import 'package:past_question_paper/views/question_view.dart';
import 'package:provider/provider.dart';
import '../viewmodels/question_viewmodel.dart';

class QuizInstructionScreen extends StatelessWidget {
  final String subjectId;
  final String topicId;

  const QuizInstructionScreen({
    super.key,
    required this.subjectId,
    required this.topicId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Instructions"),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ready to Test Your Knowledge?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Divider(color: colors.primary.withOpacity(0.3), thickness: 2),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildInstructionItem(
                        context,
                        icon: Icons.timer,
                        title: "Time Limit",
                        text: "10 minutes to complete the quiz",
                        color: colors.primary,
                      ),
                      const SizedBox(height: 16),
                      _buildInstructionItem(
                        context,
                        icon: Icons.help_outline,
                        title: "Question Format",
                        text:
                            "Multiple choice questions - select the best answer",
                        color: colors.secondary,
                      ),
                      const SizedBox(height: 16),
                      _buildInstructionItem(
                        context,
                        icon: Icons.navigation,
                        title: "Navigation",
                        text: "No going back once you submit an answer",
                        color: colors.tertiary,
                      ),
                      const SizedBox(height: 16),
                      _buildInstructionItem(
                        context,
                        icon: Icons.assignment_turned_in,
                        title: "Completion",
                        text:
                            "All questions must be answered before submitting",
                        color: colors.primary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Consumer<QuestionViewModel>(
                builder: (context, questionViewModel, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow, size: 24),
                      label: const Text(
                        "Start Quiz Now",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        questionViewModel.loadQuestions(
                            subjectId: subjectId, topicId: topicId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionScreen(
                              subjectId: subjectId,
                              topicId: topicId,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String text,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
