import 'package:flutter/material.dart';
import 'package:past_question_paper/models/question.dart';
import 'package:provider/provider.dart';
import 'package:past_question_paper/views/questionresult_screen.dart';
import 'package:past_question_paper/viewmodels/question_viewmodel.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:past_question_paper/models/question_attempt.dart';

class QuestionScreen extends StatefulWidget {
  final String subjectId;
  final String topicId;

  const QuestionScreen({
    super.key,
    required this.subjectId,
    required this.topicId,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with SingleTickerProviderStateMixin {
  int? _selectedAnswerIndex;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeQuestions());
  }

  Future<void> _initializeQuestions() async {
    final questionViewModel = context.read<QuestionViewModel>();
    await questionViewModel.loadQuestions(
      subjectId: widget.subjectId,
      topicId: widget.topicId,
    );

    if (mounted) {
      setState(() {});
      if (questionViewModel.questions.isNotEmpty) {
        questionViewModel.startTimer();
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) =>
      '${(seconds ~/ 60).toString().padLeft(2, '0')}:'
      '${(seconds % 60).toString().padLeft(2, '0')}';

  void _handleStopQuiz(QuestionViewModel viewModel) {
    if (viewModel.questions.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildStopQuizDialog(viewModel),
    );
  }

  Widget _buildStopQuizDialog(QuestionViewModel viewModel) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded,
                color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            const Text('Stop Quiz'),
          ],
        ),
        content: const Text(
          'Are you sure you want to end this quiz?\n\nYour progress will be saved and you\'ll be taken to the results screen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Quiz'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.stopTimer();
              Navigator.pop(context);
              _navigateToResults(viewModel);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Stop Quiz'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitAnswer(QuestionViewModel viewModel) async {
    if (_selectedAnswerIndex == null) return;

    final currentQuestion = viewModel.currentQuestion!;
    final selectedAnswer = currentQuestion.answers[_selectedAnswerIndex!];

    final attempt = QuestionAttempt(
      questionId: currentQuestion.id,
      selectedAnswerId: selectedAnswer.id,
      correctAnswerId: currentQuestion.correctAnswerId,
      timestamp: DateTime.now(),
    );

    try {
      final userViewModel = context.read<UserViewModel>();
      await userViewModel.updateProgress(
        questionAttempt: attempt,
        topicId: widget.topicId,
        subjectId: widget.subjectId,
        totalQuestionsInTopic: viewModel.questions.length,
      );

      viewModel.submitAnswer(
        context,
        currentQuestion.id,
        selectedAnswer.id,
        currentQuestion.correctAnswerId,
      );

      if (viewModel.isLastQuestion) {
        await _handleLastQuestion(userViewModel, viewModel);
        _navigateToResults(viewModel);
      } else {
        _resetQuestionState(viewModel);
      }
    } catch (e) {
      _showErrorSnackBar('Error saving progress: ${e.toString()}');
    }
  }

  Future<void> _handleLastQuestion(
      UserViewModel userViewModel, QuestionViewModel viewModel) async {
    final progress = await userViewModel.calculateTopicProgress(
      widget.topicId,
      viewModel.questions.length,
    );

    if (progress >= 100) {
      await userViewModel.markTopicAsCompleted(
        widget.topicId,
        widget.subjectId,
      );
    }
  }

  void _resetQuestionState(QuestionViewModel viewModel) {
    viewModel.nextQuestion();
    setState(() => _selectedAnswerIndex = null);
    _animationController
      ..reset()
      ..forward();
  }

  void _navigateToResults(QuestionViewModel viewModel) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultsScreen(
          questions: viewModel.questions,
          userAnswers: viewModel.userAnswers,
          timeSpent: 600 - viewModel.remainingTime,
          onReviewTap: () => Navigator.pop(context),
          onRetryTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionScreen(
                subjectId: widget.subjectId,
                topicId: widget.topicId,
              ),
            ),
          ),
          onExitTap: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final viewModel = context.read<QuestionViewModel>();
    if (viewModel.questions.isEmpty) {
      Navigator.pop(context);
      return false;
    }
    _handleStopQuiz(viewModel);
    return false;
  }

  Widget _buildAnswerOption(
      BuildContext context, int index, String answerText) {
    final isSelected = _selectedAnswerIndex == index;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
          color: isSelected ? theme.primaryColor : theme.cardColor,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _selectedAnswerIndex = index),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _buildAnswerIndicator(isSelected, theme, index),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      answerText,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 17,
                        color: isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle_rounded,
                        color: Colors.white.withOpacity(0.9), size: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerIndicator(bool isSelected, ThemeData theme, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.white : theme.primaryColor.withOpacity(0.1),
        border: Border.all(
          color: isSelected
              ? theme.primaryColor
              : theme.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          String.fromCharCode(65 + index),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? theme.primaryColor
                : theme.primaryColor.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Consumer<QuestionViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) return _buildLoadingState();
          if (viewModel.errorMessage != null)
            return _buildErrorState(viewModel);
          if (viewModel.questions.isEmpty) return _buildEmptyState();

          final currentQuestion = viewModel.currentQuestion;
          return currentQuestion == null
              ? _buildEmptyState()
              : _buildQuestionInterface(viewModel, currentQuestion);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor)),
            const SizedBox(height: 16),
            Text('Loading Questions...', style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(QuestionViewModel viewModel) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(viewModel.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                style: _buildButtonStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(), title: const Text('No Questions')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.quiz_outlined,
                  size: 64, color: theme.primaryColor.withOpacity(0.5)),
              const SizedBox(height: 16),
              Text('No Questions Available',
                  style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text('There are no questions available for this topic yet.',
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                style: _buildButtonStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _buildButtonStyle() => ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  Widget _buildQuestionInterface(
      QuestionViewModel viewModel, Question currentQuestion) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.1),
        title: _buildAppBarHeader(viewModel),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Text(
                  currentQuestion.questionText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildAnswerList(currentQuestion)),
              const SizedBox(height: 24),
              _buildActionButtons(viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarHeader(QuestionViewModel viewModel) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _buildProgressChip(viewModel, theme),
        const Spacer(),
        _buildTimerChip(viewModel, theme),
      ],
    );
  }

  Widget _buildProgressChip(QuestionViewModel viewModel, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Question ',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: '${viewModel.currentQuestionIndex + 1}',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '/${viewModel.questions.length}',
              style: TextStyle(
                color: theme.primaryColor.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerChip(QuestionViewModel viewModel, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_rounded,
              size: 20, color: theme.colorScheme.secondary),
          const SizedBox(width: 8),
          Text(
            _formatTime(viewModel.remainingTime),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerList(Question currentQuestion) {
    return ListView.builder(
      itemCount: currentQuestion.answers.length,
      itemBuilder: (context, index) => _buildAnswerOption(
        context,
        index,
        currentQuestion.answers[index].text,
      ),
    );
  }

  Widget _buildActionButtons(QuestionViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _selectedAnswerIndex != null
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _selectedAnswerIndex != null
                  ? () => _submitAnswer(viewModel)
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_selectedAnswerIndex != null)
                    const Icon(Icons.check_rounded, color: Colors.white),
                  if (_selectedAnswerIndex != null) const SizedBox(width: 8),
                  Text(
                    'Submit Answer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _selectedAnswerIndex != null
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          icon: Icon(Icons.stop_circle_rounded,
              color: Theme.of(context).colorScheme.error),
          label: Text(
            'Stop',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            side: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _handleStopQuiz(viewModel),
        ),
      ],
    );
  }
}
