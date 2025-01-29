/* import 'package:flutter/material.dart';
import 'package:past_question_paper/common_widgets/LottieProgressIndicator.dart';
import 'package:past_question_paper/features/core/Routes/routes.dart';
import 'package:past_question_paper/features/core/provider/quizprovider.dart';
import 'package:past_question_paper/features/core/screens/dashboard/quiz_instruction_screen.dart';
import 'package:past_question_paper/services/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(207, 0, 2, 3),
        title: const Text('Quiz List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              navigatorKey.currentState
                  ?.popAndPushNamed(RouteManager.quizSettingsPage);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Consumer<QuizProvider>(
          builder: (context, quizProvider, child) {
            if (quizProvider.loading) {
              return const Center(
                child: LottieProgressIndicator(
                  animationPath:
                      'assets/animations/loading.json', // Path to your Lottie animation file
                ),
              );
            }

            if (quizProvider.visibleQuestionPapers.isEmpty) {
              return const Center(child: Text('No quizzes available.'));
            }

            return ListView.builder(
              itemCount: quizProvider.visibleQuestionPapers.length,
              itemBuilder: (context, index) {
                var paper = quizProvider.visibleQuestionPapers[index];
                return Card(
                  elevation: 1, // Adds shadow to the card
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QuizInstructionScreen(paperId: paper['id']),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 8.0,
                          height: 100.0,
                          color: index % 2 == 0
                              ? Colors.amber
                              : Colors.grey, // Alternating colors
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    paper['image_url'] != null &&
                                            paper['image_url'].isNotEmpty
                                        ? SvgPicture.asset(
                                            paper['image_url'],
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(Icons.description,
                                            size: 50), // Fallback icon
                                    const SizedBox(width: 16.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          paper['title'] ?? 'Quiz Title',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          paper['description'] ??
                                              'No description available.',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Icon(Icons.arrow_forward_ios,
                                        color: Colors.grey[600]),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  paper['date'] ?? '',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
 */