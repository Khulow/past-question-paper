import 'package:flutter/material.dart';
import 'package:past_question_paper/views/homescreen1.dart';
import 'package:past_question_paper/views/login.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, authProvider, child) {
        // Directly check if the user is logged in
        if (authProvider.currentUser != null) {
          return const HomeScreen1();
        } else {
          return const Login();
        }
      },
    );
  }
}
