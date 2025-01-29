import 'package:flutter/material.dart';
import 'package:past_question_paper/common_widgets/app_textfield.dart';
import 'package:past_question_paper/common_widgets/validators.dart';
import 'package:past_question_paper/miscellaneous/constants/sizes.dart';
import 'package:past_question_paper/miscellaneous/constants/text_strings.dart';
import 'package:past_question_paper/services/helper_user.dart';
import 'package:past_question_paper/utils/theme/widget_themes/text_themes.dart';
import 'package:past_question_paper/views/forget_password.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              validator: Validators.validateEmail,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              labelText: 'Please enter email address',
              prefix: Icons.email,
            ),
            const SizedBox(height: tFormHeight - 20),
            AppTextField(
              validator: Validators.validatePassword,
              prefix: Icons.lock,
              keyboardType: TextInputType.visiblePassword,
              controller: passwordController,
              labelText: 'Please enter password',
              hideText: true,
            ),
            const SizedBox(height: tFormHeight - 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Implement forget password functionality
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgetPassword(),
                    ),
                  );
                },
                child: Text(
                  tForgetPassword,
                  style: TTextTheme.lightTextTheme.bodySmall,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  loginUserInUI(context,
                      email: emailController.text,
                      password: passwordController.text);
                },
                child: Text(tLogin.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
