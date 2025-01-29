class SubjectUserProgress {
  final String subjectId;
  final int totalTopics;
  final List<String> completedTopicIds;
  final double overallScore;

  SubjectUserProgress({
    required this.subjectId,
    required this.totalTopics,
    this.completedTopicIds = const [],
    this.overallScore = 0.0,
  });

  double get completionPercentage =>
      (completedTopicIds.length / totalTopics) * 100;

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'totalTopics': totalTopics,
      'completedTopicIds': completedTopicIds,
      'overallScore': overallScore,
    };
  }

  // Create from Firestore data
  factory SubjectUserProgress.fromMap(Map<String, dynamic> map) {
    return SubjectUserProgress(
      subjectId: map['subjectId'] as String,
      totalTopics: map['totalTopics'] as int,
      completedTopicIds: List<String>.from(map['completedTopicIds'] ?? []),
      overallScore: (map['overallScore'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Helper method for updating progress
  SubjectUserProgress copyWith({
    int? totalTopics,
    List<String>? completedTopicIds,
    double? overallScore,
  }) {
    return SubjectUserProgress(
      subjectId: subjectId,
      totalTopics: totalTopics ?? this.totalTopics,
      completedTopicIds: completedTopicIds ?? this.completedTopicIds,
      overallScore: overallScore ?? this.overallScore,
    );
  }
}
