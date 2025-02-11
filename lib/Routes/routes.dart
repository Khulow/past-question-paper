import 'package:flutter/material.dart';
import 'package:past_question_paper/views/homescreen1.dart';
import 'package:past_question_paper/views/onboarding_screen.dart';
import 'package:past_question_paper/views/question_view.dart';
import 'package:past_question_paper/views/welcome_screen.dart';
import 'package:past_question_paper/services/authentication_wrapper.dart';

//import 'package:past_question_paper/features/core/screens/dashboard/Bottom_navigation.dart';
import 'package:past_question_paper/views/profile_screen.dart';

import 'package:past_question_paper/views/loading.dart';
import 'package:past_question_paper/views/login.dart';
import 'package:past_question_paper/views/register.dart';

class RouteManager {
  // static const String splashPage = '/';
  static const String onboardingPage = '/';
  static const String loginPage = '/loginPage';
  static const String registerPage = '/registerPage';
  static const String mainPage = '/mainPage';

  static const String quizListPage = '/quizListPage';
  static const String loadingPage = '/loadingPage';
  static const String quizScreenPage = '/quizScreenPage';
  static const String quizSettingsPage = '/quizSettingsPage';
  static const String dashboardPage = '/dashboardScreenPage';
  static const String profilePage = '/profilePage';
  static const String quizResultPage = '/quizResultPage';
  static const String authenticationWrapper = '/authenticationWrapper';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      /*  case splashPage:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ); */

      case loginPage:
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );

      case registerPage:
        return MaterialPageRoute(
          builder: (context) => const Register(),
        );

      case mainPage:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen1(),
        );

      case loadingPage:
        return MaterialPageRoute(
          builder: (context) => const Loading(),
        );
/* 
       case quizListPage:
        return SlideFromBottomPageRoute(
          page: const QuizListScreen(),
        ); */

      /*  case quizScreenPage:
        return MaterialPageRoute(
          builder: (context) => QuestionScreen(
            subjectId: subjectId,
            topicId: topicId,
          ),
        );  */

      /*   case quizSettingsPage:
        return MaterialPageRoute(
          builder: (context) => const QuizSettingsScreen(),
        ); */

      /* case dashboardPage:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ); */

      case profilePage:
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        );

      /* case quizResultPage:
        return MaterialPageRoute(
          builder: (context) => const QuizResultScreen(),
        ); */

      case onboardingPage:
        return MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        );

      case authenticationWrapper:
        return MaterialPageRoute(
          builder: (context) => const AuthenticationWrapper(),
        );

      default:
        throw const FormatException('Route not found! Check routes again!');
    }
  }
}
