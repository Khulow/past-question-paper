import 'package:flutter/material.dart';
import 'package:past_question_paper/common_widgets/login/login_widgets/login_footer.dart';
import 'package:past_question_paper/common_widgets/login/login_widgets/login_form.dart';
import 'package:past_question_paper/views/dashboard/app_progress_indicator.dart';
import 'package:past_question_paper/miscellaneous/constants/image_strings.dart';
import 'package:past_question_paper/miscellaneous/constants/text_strings.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../common_widgets/form_header_widget.dart';
import '../miscellaneous/constants/sizes.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
                  //Color.fromRGBO(103, 145, 199, 1), // Pink from logo
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
                      title: tLoginTitle,
                      subTitle: tLoginSubTitle,
                      size: size,
                    ),
                    const LoginForm(),
                    const LoginFooter(),
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
