class TopicUserProgress {
  final String topicId;
  final int totalQuestions;
  final List<String> answeredQuestionIds;
  final List<String> correctQuestionIds;

  TopicUserProgress({
    required this.topicId,
    required this.totalQuestions,
    this.answeredQuestionIds = const [],
    this.correctQuestionIds = const [],
  });

  double get completionPercentage =>
      (answeredQuestionIds.length / totalQuestions) * 100;

  double get accuracyPercentage => answeredQuestionIds.isEmpty
      ? 0.0
      : (correctQuestionIds.length / answeredQuestionIds.length) * 100;

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'topicId': topicId,
      'totalQuestions': totalQuestions,
      'answeredQuestionIds': answeredQuestionIds,
      'correctQuestionIds': correctQuestionIds,
    };
  }

  // Create from Firestore data
  factory TopicUserProgress.fromMap(Map<String, dynamic> map) {
    return TopicUserProgress(
      topicId: map['topicId'] as String,
      totalQuestions: map['totalQuestions'] as int,
      answeredQuestionIds: List<String>.from(map['answeredQuestionIds'] ?? []),
      correctQuestionIds: List<String>.from(map['correctQuestionIds'] ?? []),
    );
  }

  // Helper method for updating progress
  TopicUserProgress copyWith({
    int? totalQuestions,
    List<String>? answeredQuestionIds,
    List<String>? correctQuestionIds,
  }) {
    return TopicUserProgress(
      topicId: topicId,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      answeredQuestionIds: answeredQuestionIds ?? this.answeredQuestionIds,
      correctQuestionIds: correctQuestionIds ?? this.correctQuestionIds,
    );
  }
}
