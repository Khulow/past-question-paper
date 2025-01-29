import 'package:flutter/material.dart';
import 'package:past_question_paper/Routes/routes.dart';
import 'package:past_question_paper/services/navigation_service.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:past_question_paper/common_widgets/form_header_widget.dart';
import 'package:past_question_paper/miscellaneous/constants/image_strings.dart';
import 'package:past_question_paper/miscellaneous/constants/sizes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isCheckingLogin = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move the login check to didChangeDependencies where context is available
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    if (!mounted) return;

    try {
      final userService = Provider.of<UserViewModel>(context, listen: false);
      String loginStatus = await userService.checkIfUserLoggedIn();

      if (!mounted) return;

      if (loginStatus == 'OK') {
        navigatorKey.currentState?.pushReplacementNamed(RouteManager.mainPage);
      } else {
        setState(() {
          _isCheckingLogin = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isCheckingLogin = false;
      });
      // Optionally show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to check login status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Show loading indicator while checking login status
    if (_isCheckingLogin) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              const SizedBox(height: 20),
              FormHeaderWidget(
                image: tWelcomeScreenImage,
                title: "Welcome to Past Questions",
                subTitle:
                    "Practice with real past questions and improve your exam scores",
                size: size,
              ),
              const SizedBox(height: 40),
              ...buildFeatureItems(),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    navigatorKey.currentState
                        ?.pushReplacementNamed(RouteManager.loginPage);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildFeatureItems() {
    final features = [
      {
        'icon': Icons.quiz_outlined,
        'title': 'Practice Questions',
        'description': 'Access a vast library of past exam questions',
      },
      {
        'icon': Icons.analytics_outlined,
        'title': 'Track Progress',
        'description': 'Monitor your performance and improvement',
      },
      {
        'icon': Icons.lightbulb_outline,
        'title': 'Learn from Mistakes',
        'description': 'Get detailed explanations for each answer',
      },
    ];

    return features
        .map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      feature['icon'] as IconData,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          feature['description'] as String,
                          style: TextStyle(
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
