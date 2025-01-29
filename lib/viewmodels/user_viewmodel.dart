import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:past_question_paper/services/helper_user.dart';
import 'package:past_question_paper/models/user.dart';
import 'package:past_question_paper/models/question_attempt.dart';
import 'package:past_question_paper/models/subject_user_pogress.dart';
import 'package:past_question_paper/models/overall_user_progress.dart';

class RequiresReauthException implements Exception {
  final String message;
  RequiresReauthException(this.message);
}

class UserViewModel with ChangeNotifier {
  AppUser? _user;
  auth.User? _firebaseUser;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? get user => _user;
  auth.User? get currentUser => _firebaseUser;

  bool _showUserProgress = false;
  bool get showUserProgress => _showUserProgress;

  String _userProgressText = '';
  String get userProgressText => _userProgressText;

  void setCurrentUserNull() {
    _firebaseUser = null;
    _user = null;
    notifyListeners();
  }

  Future<void> _loadUserData(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _user =
            AppUser.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading user data: $e");
    }
  }

  Future<String> checkIfUserLoggedIn() async {
    String result = 'OK';
    auth.User? user = auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      _firebaseUser = user;
      await _loadUserData(user.uid);
      notifyListeners();
    } else {
      result = 'NOT OK';
    }
    return result;
  }

  Future<String> loginUser(String email, String password) async {
    String result = 'OK';
    _showUserProgress = true;
    _userProgressText = 'Logging in...please wait...';
    notifyListeners();

    try {
      final userCredential =
          await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser = userCredential.user;

      if (_firebaseUser != null) {
        await _loadUserData(_firebaseUser!.uid);
      }
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }

    _showUserProgress = false;
    notifyListeners();
    return result;
  }

  Future<String> createUser(
      String email, String password, String displayName) async {
    String result = 'OK';
    _showUserProgress = true;
    _userProgressText = 'Creating new user...please wait...';
    notifyListeners();

    try {
      final userCredential =
          await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser = userCredential.user;

      if (_firebaseUser != null) {
        await _firebaseUser!.updateDisplayName(displayName);

        final userData = AppUser(
          id: _firebaseUser!.uid,
          email: email,
          displayName: displayName,
          createdAt: DateTime.now(),
          progress: UserProgress.empty(_firebaseUser!.uid),
        );

        await _firestore
            .collection('users')
            .doc(_firebaseUser!.uid)
            .set(userData.toMap());
        _user = userData;
      }
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }

    _showUserProgress = false;
    notifyListeners();
    return result;
  }

  Future<void> updateUserProgress(QuestionAttempt attempt) async {
    if (_user != null) {
      final updatedUser = _user!.addQuestionAttempt(attempt);
      await _firestore
          .collection('users')
          .doc(_user!.id)
          .update({'progress': updatedUser.progress.toMap()});
      _user = updatedUser;
      notifyListeners();
    }
  }

  Future<void> updateSubjectProgress(SubjectUserProgress progress) async {
    if (_user != null) {
      final updatedUser = _user!.updateSubjectProgress(progress);
      await _firestore
          .collection('users')
          .doc(_user!.id)
          .update({'progress': updatedUser.progress.toMap()});
      _user = updatedUser;
      notifyListeners();
    }
  }

  bool isUserLoggedIn() {
    return _firebaseUser != null && _user != null;
  }

  Future<void> deleteUserAccount() async {
    auth.User? user = auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).delete();
        await user.delete();
      } catch (error) {
        if (error.toString().contains('requires-recent-login')) {
          throw RequiresReauthException("Re-authentication required.");
        } else {
          debugPrint("Error deleting user account and data: $error");
        }
      }
    }
  }

  Future<void> reauthenticateUser(String email, String password) async {
    auth.User? user = auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final credential =
            auth.EmailAuthProvider.credential(email: email, password: password);
        await user.reauthenticateWithCredential(credential);
        await deleteUserAccount();
      } catch (error) {
        debugPrint("Error re-authenticating user: $error");
      }
    }
  }

  Future<void> updateUserDisplayName(String displayName) async {
    auth.User? user = auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName(displayName);
        await user.reload();
        _firebaseUser = auth.FirebaseAuth.instance.currentUser;
      } catch (error) {
        debugPrint("Error updating user's displayName: $error");
      }
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _showUserProgress = true;
    _userProgressText = 'Sending password reset email...please wait...';
    notifyListeners();

    try {
      await auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _userProgressText = 'Password reset email sent successfully.';
    } catch (e) {
      _userProgressText = getHumanReadableError(e.toString());
    }

    _showUserProgress = false;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await auth.FirebaseAuth.instance.signOut();
      setCurrentUserNull();
    } catch (e) {
      debugPrint("Error logging out: $e");
    }
  }

  Future<void> updateProgress({
    required QuestionAttempt questionAttempt,
    required String topicId,
    required String subjectId,
    required int totalQuestionsInTopic,
  }) async {
    if (_user == null) return;

    try {
      // 1. Get current progress
      final currentProgress = _user!.progress;

      // 2. Add new question attempt
      final updatedAttempts = [
        ...currentProgress.questionAttempts,
        questionAttempt
      ];

      // 3. Update topic progress
      final topicAttempts = updatedAttempts
          .where((attempt) => attempt.questionId.startsWith(topicId))
          .toList();

      final topicProgress = TopicProgress(
        topicId: topicId,
        completionPercentage:
            (topicAttempts.length / totalQuestionsInTopic) * 100,
        lastAttempted: DateTime.now(),
      );

      final updatedTopicProgress = {
        ...currentProgress.topicProgress,
        topicId: topicProgress,
      };

      // 4. Create updated progress object
      final updatedProgress = UserProgress(
        userId: _user!.id,
        subjectProgress: currentProgress.subjectProgress,
        topicProgress: updatedTopicProgress,
        questionAttempts: updatedAttempts,
      );

      // 5. Update Firestore
      await _firestore
          .collection('users')
          .doc(_user!.id)
          .update({'progress': updatedProgress.toMap()});

      // 6. Update local state
      _user = _user!.copyWith(progress: updatedProgress);
      notifyListeners();
    } catch (e) {
      print('Error updating progress: $e');
      rethrow; // Allow UI to handle error
    }
  }

  Future<double> calculateTopicProgress(
      String topicId, int totalQuestions) async {
    if (_user == null) return 0.0;

    final attempts = _user!.progress.questionAttempts
        .where((attempt) => attempt.questionId.startsWith(topicId))
        .toList();

    return (attempts.length / totalQuestions) * 100;
  }

  Future<void> markTopicAsCompleted(String topicId, String subjectId) async {
    if (_user == null) return;

    try {
      // Update subject progress to reflect completed topic
      final currentSubjectProgress = _user!.progress.subjectProgress[subjectId];
      if (currentSubjectProgress != null) {
        final updatedTopicIds = {
          ...currentSubjectProgress.completedTopicIds,
          topicId
        };

        final updatedSubjectProgress = currentSubjectProgress.copyWith(
          completedTopicIds: updatedTopicIds.toList(),
        );

        // Update Firestore and local state
        await updateSubjectProgress(updatedSubjectProgress);
      }
    } catch (e) {
      print('Error marking topic as completed: $e');
      rethrow;
    }
  }
}
