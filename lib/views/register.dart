import 'package:flutter/material.dart';
import 'package:past_question_paper/common_widgets/signup/signup_widgets/signup_form_widget.dart';
import 'package:past_question_paper/utils/theme/widget_themes/text_themes.dart';
import 'package:past_question_paper/common_widgets/app_progress_indicator.dart';
import 'package:past_question_paper/miscellaneous/constants/image_strings.dart';
import 'package:past_question_paper/miscellaneous/constants/text_strings.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:past_question_paper/views/login.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../common_widgets/form_header_widget.dart';
import '../miscellaneous/constants/sizes.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Add gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors
                      .white // Lighter purple, similar to the last 'p' in the logo
                  // Color.fromRGBO(103, 145, 199, 1), // Pink from logo
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(tDefaultSize),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormHeaderWidget(
                      image: tWelcomeScreenImage,
                      title: tSignupTitle,
                      subTitle: tSignSubTitle,
                      size: size,
                    ),
                    const SignUpFormWidget(),
                    Column(
                      children: [
                        const SizedBox(
                          height: 20,
                          width: double.infinity,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: tAlreadyHaveAnAccount,
                                  style: TTextTheme.lightTextTheme.bodyLarge,
                                ),
                                TextSpan(text: tLogin.toUpperCase())
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Selector<UserViewModel, Tuple2<bool, String>>(
            selector: (context, userService) => Tuple2(
              userService.showUserProgress,
              userService.userProgressText,
            ),
            builder: (context, value, child) {
              return value.item1
                  ? AppProgressIndicator(text: value.item2)
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}
