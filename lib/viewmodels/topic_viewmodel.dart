// viewmodels/topic_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/topic.dart';

class TopicViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Topic> _topics = [];
  bool _isLoading = false;
  String? _currentSubjectId; // Add this to track current subject

  List<Topic> get topics => _topics;
  bool get isLoading => _isLoading;

  Future<void> fetchTopics(String subjectId) async {
    // If we're already showing topics for this subject, don't reload
    if (_currentSubjectId == subjectId) return;

    _isLoading = true;
    _topics = []; // Clear previous topics
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('subjects')
          .doc(subjectId)
          .collection('topics')
          .get();

      _topics = snapshot.docs.map((doc) {
        return Topic.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      _currentSubjectId = subjectId; // Update current subject ID
    } catch (e) {
      debugPrint("Error fetching topics: $e");
      _topics = []; // Reset topics on error
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add this method to clear topics when leaving the screen
  void clearTopics() {
    _topics = [];
    _currentSubjectId = null;
    notifyListeners();
  }
}
