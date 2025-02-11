// models/subject.dart

class Subject {
  final String id;
  final String name;
  final String imageUrl;
  final int numberOfTopics;
  final String description;

  Subject({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.numberOfTopics,
    required this.description,
  });
  //
  factory Subject.fromFirestore(Map<String, dynamic> data, String id) {
    return Subject(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['image_url'] ?? '',
      numberOfTopics: data['numberOfTopics'] ?? 0,
      description: data['description'] ?? '',
    );
  }
}
