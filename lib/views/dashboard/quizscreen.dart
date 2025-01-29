/* import 'package:flutter/material.dart';
import 'package:past_question_paper/common_widgets/LottieProgressIndicator.dart';
import 'package:past_question_paper/common_widgets/circle_painter.dart';
import 'package:past_question_paper/features/core/Routes/routes.dart';
import 'package:past_question_paper/features/core/provider/quizprovider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuizProvider _quizProvider;

  double _opacity = 0.0;
  @override
  void initState() {
    super.initState();
    _opacity = 0.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
      _quizProvider = Provider.of<QuizProvider>(context, listen: false);
      _quizProvider.startTimer();
    });
  }

  @override
  void dispose() {
    _quizProvider.stopTimer();
    super.dispose();
  }

  Widget _buildLinearProgressIndicator(int currentIndex, int totalQuestions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: LinearProgressIndicator(
        value: (currentIndex + 1) / totalQuestions,
        backgroundColor: Colors.grey[300],
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        minHeight: 10,
      ),
    );
  }

  Widget _buildCustomStepProgressIndicator(
      int currentIndex, int totalQuestions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: StepProgressIndicator(
        totalSteps: totalQuestions,
        currentStep: currentIndex + 1,
        size: 20,
        selectedColor: Colors.pinkAccent,
        unselectedColor: Colors.grey[200]!,
        customStep: (index, color, _) => color == Colors.purple
            ? Container(
                color: color,
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              )
            : Container(
                color: color,
                child: const Icon(
                  Icons.remove,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await _showExitDialog(context);
        return shouldExit;
      },
      child: Scaffold(
        //backgroundColor: const Color(0xFF05192D),
        appBar: AppBar(
          title: const Text("Quiz"),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 250, 250, 250),
                Color.fromARGB(255, 231, 229, 229),
              ],
            ),
          ),
          child: CustomPaint(
            painter: BackgroundPainter(),
            child: Consumer<QuizProvider>(
              builder: (context, quizProvider, child) {
                int minutes = quizProvider.remainingTime ~/ 60;
                int seconds = quizProvider.remainingTime % 60;
                if (quizProvider.loading) {
                  return Center(
                      child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LottieProgressIndicator(
                          height: 5,
                          width: CircularProgressIndicator.strokeAlignCenter,
                          animationPath: 'assets/animations/loading1.json',
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Loading questions...",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ));
                }

                if (quizProvider.questions.isEmpty) {
                  return const Center(child: Text("No questions available."));
                }

                int currentIndex = quizProvider.currentQuestionIndex;
                var currentQuestion = quizProvider.questions[currentIndex];

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildLinearProgressIndicator(
                          currentIndex, quizProvider.questions.length),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          '$minutes:${seconds.toString().padLeft(2, '0')} minutes remaining',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: _opacity,
                                child: Text(
                                  currentQuestion.question,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Select the best answer from the options below:",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.redAccent,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              ...currentQuestion.answers.map((answer) {
                                return AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: _opacity,
                                  child: RadioListTile<String>(
                                    title: Text(
                                      answer.answer,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                    value: answer.identifier,
                                    groupValue: quizProvider
                                        .selectedAnswers[currentQuestion.id],
                                    onChanged: quizProvider.isSubmitted
                                        ? null
                                        : (value) {
                                            quizProvider.selectAnswer(
                                                currentQuestion.id, value!);
                                          },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (currentIndex > 0)
                              TextButton(
                                onPressed: () =>
                                    quizProvider.previousQuestion(),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 12.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                child: const Text('Previous'),
                              ),
                            if (currentIndex <
                                quizProvider.questions.length - 1)
                              TextButton(
                                onPressed: () => quizProvider.nextQuestion(),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 12.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                child: const Text('Next'),
                              ),
                            if (currentIndex ==
                                    quizProvider.questions.length - 1 &&
                                !quizProvider.isSubmitted)
                              TextButton(
                                onPressed: () {
                                  quizProvider.submitQuiz();
                                  Navigator.of(context).popAndPushNamed(
                                      RouteManager.quizResultPage);
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 12.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                child: const Text('Submit'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> _showExitDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Exit Quiz'),
      content: const Text('Do you really want to stop the quiz?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            Provider.of<QuizProvider>(context, listen: false).stopQuiz();
            Navigator.of(context).pop(true);
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}
 */