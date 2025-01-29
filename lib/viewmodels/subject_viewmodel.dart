// viewmodel/subject_viewmodel.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:past_question_paper/models/subject.dart';

class SubjectViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Subject> _subjects = [];
  bool _isLoading = false;

  List<Subject> get subjects => _subjects;
  bool get isLoading => _isLoading;

  Future<void> fetchSubjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore.collection('subjects').get();

      _subjects = snapshot.docs.map((doc) {
        return Subject.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      // Handle errors here
    }

    _isLoading = false;
    notifyListeners();
  }
}
