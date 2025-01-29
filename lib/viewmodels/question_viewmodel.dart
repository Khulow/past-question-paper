import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:past_question_paper/models/answer.dart';
import 'package:past_question_paper/models/question.dart';
import 'package:past_question_paper/models/question_attempt.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class QuestionViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;
  final Map<String, String> _userAnswers = {};
  bool _isComplete = false;

  // Add a reference to track current topic and subject
  String? currentTopicId;
  String? currentSubjectId;

  // Timer related fields
  Timer? _timer;
  int _remainingTime = 600; // 10 minutes default
  bool _isTimerActive = false;
  // Add callback for timer completion
  VoidCallback? _onTimerComplete;
  bool _isTimeUp = false;
  bool get isTimeUp => _isTimeUp;
  // Getters
  List<Question> get questions => _questions;
  Question? get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentQuestionIndex] : null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get remainingTime => _remainingTime;
  bool get isTimerActive => _isTimerActive;
  Map<String, String> get userAnswers => _userAnswers;
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;
  bool get areAllQuestionsAnswered =>
      _questions.isNotEmpty && _userAnswers.length == _questions.length;

  // Getter for quiz completion status
  bool get isComplete => _isComplete;

  void startReviewMode() {
    _currentQuestionIndex = 0;
    notifyListeners();
  }

  // Enhanced question loading with proper collection structure
  Future<void> loadQuestions({
    required String subjectId,
    required String topicId,
  }) async {
    currentTopicId = topicId;
    currentSubjectId = subjectId;
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Get questions from the nested collection
      final questionsSnapshot = await _firestore
          .collection('subjects')
          .doc(subjectId)
          .collection('topics')
          .doc(topicId)
          .collection('questions')
          .get();

      // Load questions and their answers
      _questions = await Future.wait(questionsSnapshot.docs.map((doc) async {
        // Get the base question data
        Map<String, dynamic> questionData = doc.data();
        questionData['id'] = doc.id;

        // Fetch answers for this question
        final answersSnapshot = await doc.reference.collection('answers').get();

        // Convert answer documents to Answer objects
        List<Answer> answers = answersSnapshot.docs.map((answerDoc) {
          return Answer(
            id: answerDoc
                .id, // Use the document ID (A, B, C, D) as the answer ID
            text: answerDoc.data()['text'] ?? '',
          );
        }).toList();

        // Create the Question object with all data
        return Question(
          id: doc.id,
          questionText: questionData['question'] ?? '',
          imageUrl: questionData['image_url'] ?? '',
          correctAnswerId: questionData['correct_answer'] ?? '',
          answers: answers,
        );
      }).toList());

      // Reset state for new questions
      _currentQuestionIndex = 0;
      _userAnswers.clear();
    } catch (e) {
      _errorMessage = 'Error loading questions: ${e.toString()}';
      _questions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Enhanced answer submission
  void submitAnswer(BuildContext context, String questionId,
      String selectedAnswerId, String correctAnswerId) {
    // 1. Store the user's answer locally
    _userAnswers[questionId] = selectedAnswerId;

    // 2. Create a question attempt record
    final attempt = QuestionAttempt(
        questionId: questionId,
        selectedAnswerId: selectedAnswerId,
        correctAnswerId: correctAnswerId,
        timestamp: DateTime.now());

    // 3. Update progress in UserViewModel
    if (currentTopicId != null && currentSubjectId != null) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      userViewModel.updateProgress(
          questionAttempt: attempt,
          topicId: currentTopicId!,
          subjectId: currentSubjectId!,
          totalQuestionsInTopic: _questions.length);
    }

    notifyListeners();
  }

  // Navigation methods
  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  // Timer methods
  // Modified timer methods
  void startTimer({VoidCallback? onComplete}) {
    _cancelTimer();
    _isTimerActive = true;
    _isTimeUp = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0 && !_isTimeUp) {
        _remainingTime--;
        if (_remainingTime > 0) {
          notifyListeners();
        } else {
          _handleTimeUp(timer, onComplete);
        }
      }
    });
  }

  void _handleTimeUp(Timer timer, VoidCallback? onComplete) {
    _isTimeUp = true;
    _cancelTimer();
    if (onComplete != null) {
      // Schedule the callback after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) => onComplete());
    }
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void stopTimer({bool notify = true}) {
    _cancelTimer();
    _isTimerActive = false;
    if (notify) {}
    notifyListeners();
  }

  // Check if a specific answer is selected
  bool isAnswerSelected(String questionId, String answerId) {
    return _userAnswers[questionId] == answerId;
  }

  void completeQuiz() {
    _isComplete = true;
    notifyListeners();
  }

  // Calculate score
  int calculateScore() {
    int correctAnswers = 0;
    for (var question in _questions) {
      final userAnswer = _userAnswers[question.id];
      if (userAnswer != null && userAnswer == question.correctAnswerId) {
        correctAnswers++;
      }
    }
    return correctAnswers;
  }

  @override
  void dispose() {
    stopTimer(notify: false);
    super.dispose();
  }

  // Enhanced reset method
  void resetQuiz({bool notify = true}) {
    _currentQuestionIndex = 0;
    _userAnswers.clear();
    _remainingTime = 600;
    _isTimerActive = false;
    if (notify) {
      notifyListeners();
    }
  }
}
