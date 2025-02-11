import 'package:flutter/material.dart';
import 'package:past_question_paper/common_widgets/validators.dart';
import 'package:past_question_paper/common_widgets/app_textfield.dart';
import 'package:past_question_paper/services/helper_user.dart';
import 'package:past_question_paper/common_widgets/app_progress_indicator.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  labelText: 'Enter your email address',
                  validator: (value) => Validators.validateEmail(value),
                  prefix: Icons.email,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      forgetPasswordInUI(
                        context,
                        email: _emailController.text,
                      );
                    },
                    child: const Text('Reset Password'),
                  ),
                ),
              ],
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
