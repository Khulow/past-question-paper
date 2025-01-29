import 'package:flutter/material.dart';
import 'package:past_question_paper/Routes/routes.dart';
import 'package:past_question_paper/miscellaneous/constants/image_strings.dart';
import 'package:past_question_paper/miscellaneous/constants/sizes.dart';
import 'package:past_question_paper/miscellaneous/constants/text_strings.dart';
import 'package:past_question_paper/services/navigation_service.dart';
import 'package:past_question_paper/utils/theme/widget_themes/text_themes.dart';
import 'package:past_question_paper/views/register.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //const Text("OR"),
        const SizedBox(
          width: double.infinity,
          /*   child: OutlinedButton.icon(
              icon: const Image(
                image: AssetImage(tGoogleLogoImage),
                width: 20.0,
              ),
              onPressed: () {},
              label: const Text(tSignInWithGoogle)), */
        ),

        TextButton(
            onPressed: () {
              navigatorKey.currentState!.pushNamed(RouteManager.registerPage);
            },
            child: Text.rich(TextSpan(
                //text: tDontHaveAccount,
                //style: TTextTheme.lightTextTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: tDontHaveAccount,
                    style: TTextTheme.lightTextTheme.bodyLarge,
                  ),
                  TextSpan(
                    text: tSignUp.toUpperCase(),
                  )
                ])))
      ],
    );
  }
}
