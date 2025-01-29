// models/answer.dart

class Answer {
  final String id;
  final String text;

  const Answer({
    required this.id,
    required this.text,
  });

  factory Answer.fromFirestore(Map<String, dynamic> data) {
    return Answer(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }

  // Add equality operator for comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Answer && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
