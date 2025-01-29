import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:past_question_paper/models/overall_user_progress.dart';
import 'package:past_question_paper/models/question_attempt.dart';
import 'package:past_question_paper/models/subject_user_pogress.dart';

class AppUser {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final DateTime createdAt;
  final UserProgress progress;

  AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.createdAt,
    required this.progress,
  });

  // Progress helper methods
  double get overallAccuracy => progress.getOverallAccuracy();
  int get completedSubjects => progress.getTotalCompletedSubjects();
  int get completedTopics => progress.getTotalCompletedTopics();

  bool hasCompletedTopic(String topicId) {
    return progress.topicProgress[topicId]?.completionPercentage == 100;
  }

  double getSubjectProgress(String subjectId) {
    return progress.subjectProgress[subjectId]?.completionPercentage ?? 0.0;
  }

  // Firestore serialization from a map
  factory AppUser.fromFirestore(Map<String, dynamic> data, String id) {
    return AppUser(
      id: id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoURL: data['photoURL'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      progress: UserProgress.fromMap(data['progress'] ?? {}, id),
    );
  }

  // Firestore serialization from a DocumentSnapshot
  factory AppUser.fromFirestoreDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser.fromFirestore(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'progress': progress.toMap(),
    };
  }

  // Immutable updates
  AppUser copyWith({
    String? email,
    String? displayName,
    String? photoURL,
    UserProgress? progress,
  }) {
    return AppUser(
      id: id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt,
      progress: progress ?? this.progress,
    );
  }

  // Record new question attempt
  AppUser addQuestionAttempt(QuestionAttempt attempt) {
    var updatedAttempts = [...progress.questionAttempts, attempt];
    var updatedProgress = UserProgress(
      userId: id,
      subjectProgress: progress.subjectProgress,
      topicProgress: progress.topicProgress,
      questionAttempts: updatedAttempts,
    );
    return copyWith(progress: updatedProgress);
  }

  // Update subject progress
  AppUser updateSubjectProgress(SubjectUserProgress subjectProgress) {
    var updatedSubjectProgress = Map<String, SubjectUserProgress>.from(
      progress.subjectProgress,
    )..[subjectProgress.subjectId] = subjectProgress;

    var updatedProgress = UserProgress(
      userId: id,
      subjectProgress: updatedSubjectProgress,
      topicProgress: progress.topicProgress,
      questionAttempts: progress.questionAttempts,
    );
    return copyWith(progress: updatedProgress);
  }
}
