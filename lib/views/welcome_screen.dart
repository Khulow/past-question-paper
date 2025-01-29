import 'package:flutter/material.dart';
import 'package:past_question_paper/Routes/routes.dart';
import 'package:past_question_paper/common_widgets/form_header_widget.dart';
import 'package:past_question_paper/miscellaneous/constants/image_strings.dart';
import 'package:past_question_paper/miscellaneous/constants/sizes.dart';
import 'package:past_question_paper/services/navigation_service.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(tDefaultSize),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Header with Image and Text
                    FormHeaderWidget(
                      image: tWelcomeScreenImage,
                      title: "Welcome to Past Questions",
                      subTitle:
                          "Practice with real past questions and improve your exam scores",
                      size: size,
                    ),

                    const SizedBox(height: 40),

                    // Features List
                    ...buildFeatureItems(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Button Container
            Container(
              padding: const EdgeInsets.all(tDefaultSize),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Login Screen
                  navigatorKey.currentState!
                      .popAndPushNamed(RouteManager.loginPage);
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildFeatureItems() {
    final features = [
      {
        'icon': Icons.quiz_outlined,
        'title': 'Practice Questions',
        'description': 'Access a vast library of past exam questions'
      },
      {
        'icon': Icons.analytics_outlined,
        'title': 'Track Progress',
        'description': 'Monitor your performance and improvement'
      },
      {
        'icon': Icons.lightbulb_outline,
        'title': 'Learn from Mistakes',
        'description': 'Get detailed explanations for each answer'
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
                      color: Colors.grey.withValues(alpha: 200),
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
