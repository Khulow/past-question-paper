import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionAttempt {
  final String questionId;
  final String selectedAnswerId;
  final String correctAnswerId;
  final DateTime timestamp;

  bool get isCorrect => selectedAnswerId == correctAnswerId;

  QuestionAttempt({
    required this.questionId,
    required this.selectedAnswerId,
    required this.correctAnswerId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'selectedAnswerId': selectedAnswerId,
      'correctAnswerId': correctAnswerId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Create from Firestore data
  factory QuestionAttempt.fromMap(Map<String, dynamic> map) {
    return QuestionAttempt(
      questionId: map['questionId'] as String,
      selectedAnswerId: map['selectedAnswerId'] as String,
      correctAnswerId: map['correctAnswerId'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
