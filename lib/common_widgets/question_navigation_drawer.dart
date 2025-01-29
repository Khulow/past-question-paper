import 'package:flutter/material.dart';
import 'package:past_question_paper/models/question.dart';

class QuestionNavigationDrawer extends StatelessWidget {
  final List<Question> questions;
  final Map<String, String> userAnswers;
  final int currentIndex;
  final Function(int) onQuestionSelected;

  const QuestionNavigationDrawer({
    super.key,
    required this.questions,
    required this.userAnswers,
    required this.currentIndex,
    required this.onQuestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Question Navigator',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${userAnswers.length}/${questions.length} Answered',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: questions.isEmpty
                      ? 0
                      : userAnswers.length / questions.length,
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final isAnswered = userAnswers.containsKey(question.id);
                final isCorrect = isAnswered &&
                    userAnswers[question.id] == question.correctAnswerId;
                final isCurrent = index == currentIndex;

                return InkWell(
                  onTap: () {
                    onQuestionSelected(index);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? Colors.blue
                          : isAnswered
                              ? isCorrect
                                  ? Colors.green.shade100
                                  : Colors.red.shade100
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: isCurrent
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isCurrent ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
