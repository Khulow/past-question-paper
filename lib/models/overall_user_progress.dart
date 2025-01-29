import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:past_question_paper/models/question_attempt.dart';
import 'package:past_question_paper/models/subject_user_pogress.dart';

class UserProgress {
  final String userId;
  final Map<String, SubjectUserProgress> subjectProgress;
  final Map<String, TopicProgress> topicProgress;
  final List<QuestionAttempt> questionAttempts;

  UserProgress({
    required this.userId,
    required this.subjectProgress,
    required this.topicProgress,
    required this.questionAttempts,
  });

  static UserProgress empty(String userId) {
    return UserProgress(
      userId: userId, subjectProgress: {}, topicProgress: {},
      questionAttempts: [],

      // initialize other fields with default values
    );
  }

  // Calculate overall accuracy
  double getOverallAccuracy() {
    if (questionAttempts.isEmpty) return 0.0;

    int correctAnswers =
        questionAttempts.where((attempt) => attempt.isCorrect).length;
    return (correctAnswers / questionAttempts.length) * 100;
  }

  // Get total completed subjects
  int getTotalCompletedSubjects() {
    return subjectProgress.values
        .where((subject) => subject.completionPercentage == 100)
        .length;
  }

  // Get total completed topics
  int getTotalCompletedTopics() {
    return topicProgress.values
        .where((topic) => topic.completionPercentage == 100)
        .length;
  }

  // Convert UserProgress to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'subjectProgress': subjectProgress.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
      'topicProgress': topicProgress.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
      'questionAttempts':
          questionAttempts.map((attempt) => attempt.toMap()).toList(),
    };
  }

  // Create UserProgress from Firestore data
  factory UserProgress.fromMap(Map<String, dynamic> map, String userId) {
    return UserProgress(
      userId: userId,
      subjectProgress: (map['subjectProgress'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              SubjectUserProgress.fromMap(value as Map<String, dynamic>),
            ),
          ) ??
          {},
      topicProgress: (map['topicProgress'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              TopicProgress.fromMap(value as Map<String, dynamic>),
            ),
          ) ??
          {},
      questionAttempts: (map['questionAttempts'] as List<dynamic>?)
              ?.map((attempt) =>
                  QuestionAttempt.fromMap(attempt as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// TopicProgress class (if not already defined elsewhere)
class TopicProgress {
  final String topicId;
  final double completionPercentage;
  final DateTime lastAttempted;

  TopicProgress({
    required this.topicId,
    required this.completionPercentage,
    required this.lastAttempted,
  });

  Map<String, dynamic> toMap() {
    return {
      'topicId': topicId,
      'completionPercentage': completionPercentage,
      'lastAttempted': Timestamp.fromDate(lastAttempted),
    };
  }

  factory TopicProgress.fromMap(Map<String, dynamic> map) {
    return TopicProgress(
      topicId: map['topicId'] as String,
      completionPercentage: (map['completionPercentage'] as num).toDouble(),
      lastAttempted: (map['lastAttempted'] as Timestamp).toDate(),
    );
  }
}
