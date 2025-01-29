import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:past_question_paper/Routes/routes.dart';
import 'package:past_question_paper/services/bottom_nav_bar.dart';
import 'package:past_question_paper/services/navigation_service.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:past_question_paper/utils/theme/theme.dart';
import 'package:past_question_paper/viewmodels/question_viewmodel.dart';
import 'package:past_question_paper/viewmodels/subject_viewmodel.dart';
import 'package:past_question_paper/viewmodels/topic_viewmodel.dart';
import 'package:past_question_paper/views/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuestionViewModel()),
        ChangeNotifierProvider(create: (_) => SubjectViewModel()),
        ChangeNotifierProvider(create: (_) => TopicViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
        // Add more providers if needed
      ],
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          themeMode: ThemeMode.light,
          //home: const OnboardingScreen(),
          initialRoute: RouteManager.onboardingPage,
          onGenerateRoute: RouteManager.generateRoute,
        );
      },
    );
  }
}
