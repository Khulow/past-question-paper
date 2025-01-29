import 'package:flutter/material.dart';
import 'package:past_question_paper/views/homescreen1.dart';
import 'package:past_question_paper/views/login.dart';
import 'package:past_question_paper/views/register.dart';
import 'package:past_question_paper/views/welcome_screen.dart';
//import 'package:past_question_paper/features/core/screens/dashboard/Bottom_navigation.dart';
import 'package:past_question_paper/views/dashboard/Home_screen.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:past_question_paper/views/subject_view.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, authProvider, child) {
        // Directly check if the user is logged in
        if (authProvider.currentUser != null) {
          return HomeScreen1();
        } else {
          return const Login();
        }
      },
    );
  }
}
