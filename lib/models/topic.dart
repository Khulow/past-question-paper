// models/topic.dart

class Topic {
  final String id;
  final String name;

  Topic({
    required this.id,
    required this.name,
  });

  factory Topic.fromFirestore(Map<String, dynamic> data, String id) {
    return Topic(
      id: id,
      name: data['name'] ?? '',
    );
  }
}
