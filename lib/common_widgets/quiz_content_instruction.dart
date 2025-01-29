/* import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:past_question_paper/features/core/provider/quizprovider.dart';
import 'package:past_question_paper/features/core/screens/dashboard/quizscreen.dart';
import 'package:provider/provider.dart';

class QuizInstructionsContent extends StatelessWidget {
  final String paperId;

  const QuizInstructionsContent({super.key, required this.paperId});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        var paper = quizProvider.questionPapers
            .firstWhere((paper) => paper['id'] == paperId);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Scrollbar(
            thumbVisibility: true,
            radius: const Radius.circular(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // Your content here...
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/book.svg',
                        width: 18,
                        height: 18,
                        //color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        paper['title'] ?? 'Unknown Title',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/description.svg',
                        width: 18,
                        height: 18,
                        //color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          paper['description'] ?? 'No description available',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/question_mark.svg',
                        width: 18,
                        height: 18,
                        //color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Number of questions: ${paper['questions_count'] ?? 0}',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/info.svg',
                        width: 28,
                        height: 28,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                            'You are to be evaluated on this paper. Keep in mind each time you take a quiz, you will be presented with random questions. Make sure to answer all the questions to the best of your ability.',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    onPressed: () {
                      quizProvider.fetchQuizData(paperId);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizScreen(),
                        ),
                      );
                    },
                    child: const Center(child: Text('Start Quiz')),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
 */