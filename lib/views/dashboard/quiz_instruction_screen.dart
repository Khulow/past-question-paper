/* import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:past_question_paper/features/core/provider/quizprovider.dart';
import 'package:past_question_paper/features/core/screens/dashboard/quizscreen.dart';
import 'package:provider/provider.dart';

class QuizInstructionScreen extends StatelessWidget {
  final String paperId;

  const QuizInstructionScreen({super.key, required this.paperId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz Instructions',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          var paper = quizProvider.questionPapers
              .firstWhere((paper) => paper['id'] == paperId);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/book.svg',
                      width: 20,
                      height: 20,
                      //color: Colors.blue,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      paper['title'] ?? 'Unknown Title',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/description.svg',
                      width: 20,
                      height: 20,
                      //color: Colors.blue,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        paper['description'] ?? 'No description available',
                        style: GoogleFonts.roboto(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/question_mark.svg',
                      width: 20,
                      height: 20,
                      //color: Colors.blue,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Number of questions: ${paper['questions_count'] ?? 0}',
                      style: GoogleFonts.roboto(fontSize: 14),
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
                      //color: Colors.blue,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'You are to be evaluated on this paper. Keep in mind each time you take a quiz, you will be presented with random questions. Make sure to answer all the questions to the best of your ability.',
                        style: GoogleFonts.roboto(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      quizProvider.fetchQuizData(paperId);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      textStyle: GoogleFonts.roboto(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text(
                      'Start Practice',
                      style: GoogleFonts.roboto(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
 */