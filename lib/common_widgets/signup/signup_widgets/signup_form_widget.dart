import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:past_question_paper/common_widgets/app_textfield.dart';
import 'package:past_question_paper/common_widgets/validators.dart';
import 'package:past_question_paper/services/helper_user.dart';
import 'package:past_question_paper/miscellaneous/constants/sizes.dart';
import 'package:past_question_paper/miscellaneous/constants/text_strings.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static const String _privacyPolicyUrl =
      'https://pqp.kinetixes.com/privacy-policy/';
  static const String _termsUrl = 'https://pqp.kinetixes.com/terms/';
  late UserViewModel userService;

  @override
  @override
  void initState() {
    super.initState();
    userService = Provider.of<UserViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            keyboardType: TextInputType.name,
            validator: Validators.validateName,
            controller: fullNameController,
            labelText: "Please enter your full name",
            prefix: Icons.person,
          ),
          const SizedBox(height: tFormHeight - 20),
          AppTextField(
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            controller: emailController,
            labelText: "Please enter your email",
            prefix: Icons.email,
          ),
          const SizedBox(height: tFormHeight - 20),
          AppTextField(
            keyboardType: TextInputType.visiblePassword,
            validator: Validators.validatePassword,
            controller: passwordController,
            labelText: "Please enter your password",
            prefix: Icons.lock,
            hideText: true,
          ),
          const SizedBox(height: tFormHeight - 10),

          // Privacy Policy and Terms Text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  const TextSpan(
                    text: 'By continuing, you agree to our ',
                  ),
                  TextSpan(
                    text: 'Terms of Service',
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _launchURL(_termsUrl),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _launchURL(_privacyPolicyUrl),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: tFormHeight - 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                createNewUserInUI(context,
                    userService: userService,
                    email: emailController.text,
                    password: passwordController.text,
                    name: fullNameController.text);
              },
              child: Text(tSignUp.toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }
}
