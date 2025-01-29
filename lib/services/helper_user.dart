// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:past_question_paper/Routes/routes.dart';
import 'package:past_question_paper/common_widgets/validators.dart';
import 'package:past_question_paper/services/bottom_nav_bar.dart';
import 'package:past_question_paper/services/custom_snackbar.dart';
import 'package:past_question_paper/services/navigation_service.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:past_question_paper/views/login.dart';
import 'package:provider/provider.dart';

void createNewUserInUI(
  BuildContext context, {
  required String email,
  required String password,
  required String name,
  required UserViewModel userService,
}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  // Check if all fields are filled
  if (email.isEmpty || password.isEmpty || name.isEmpty) {
    CustomSnackbar.showError(
      context: context,
      message: 'Please enter all fields',
    );
    return;
  }

  // Validate email
  String? emailError = Validators.validateEmail(email);
  if (emailError != null) {
    CustomSnackbar.showError(
      context: context,
      message: emailError,
    );
    return;
  }

  // Validate password
  String? passwordError = Validators.validatePassword(password);
  if (passwordError != null) {
    CustomSnackbar.showError(
      context: context,
      message: passwordError,
    );
    return;
  }

  // Validate name
  String? nameError = Validators.validateName(name);
  if (nameError != null) {
    CustomSnackbar.showError(
      context: context,
      message: nameError,
    );
    return;
  }

  try {
    // Use createUser from UserViewModel instead of direct Firebase call
    String result = await userService.createUser(email, password, name);

    if (result == 'OK') {
      CustomSnackbar.showSuccess(
        context: context,
        message: 'Account created successfully!',
      );

      // Navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      CustomSnackbar.showError(
        context: context,
        message: getHumanReadableError(result),
      );
    }
  } catch (e) {
    CustomSnackbar.showError(
      context: context,
      message: getHumanReadableError(e.toString()),
    );
  }
}

void loginUserInUI(BuildContext context,
    {required String email, required String password}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  // Check if all fields are filled
  if (email.isEmpty || password.isEmpty) {
    CustomSnackbar.showError(
      context: context,
      message: 'Please enter both fields!',
    );
    return;
  }
  // Validate email
  String? emailError = Validators.validateEmail(email);
  if (emailError != null) {
    CustomSnackbar.showError(
      context: context,
      message: emailError,
    );
    return;
  }
  // Validate password
  String? passwordError = Validators.validatePassword(password);
  if (passwordError != null) {
    CustomSnackbar.showError(
      context: context,
      message: passwordError,
    );
    return;
  }
  try {
    // Get UserViewModel instance using Provider
    final userService = Provider.of<UserViewModel>(context, listen: false);
    // Use loginUser from UserViewModel instead of direct Firebase call
    String result = await userService.loginUser(email, password);
    if (result == 'OK') {
      CustomSnackbar.showSuccess(
        context: context,
        message: 'Login successful!',
      );
      //avigator.of(context).popAndPushNamed(RouteManager.mainPage);
      // Navigate to main screen
      navigatorKey.currentState?.popAndPushNamed(RouteManager.mainPage);
    } else {
      CustomSnackbar.showError(
        context: context,
        message: getHumanReadableError(result),
      );
    }
  } catch (e) {
    CustomSnackbar.showError(
      context: context,
      message: getHumanReadableError(e.toString()),
    );
  }
}

void resetPasswordInUI(BuildContext context, {required String email}) async {
  if (email.isEmpty) {
    CustomSnackbar.showError(
      context: context,
      message:
          'Please enter your email address then click on Reset Password again!',
    );
  } else {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      CustomSnackbar.showSuccess(
        context: context,
        message: 'Successfully sent password reset. Please check your mail',
      );
    } catch (e) {
      CustomSnackbar.showError(
        context: context,
        message: getHumanReadableError(e.toString()),
      );
    }
  }
}

void logoutUserInUI(BuildContext context, UserViewModel userService,
    BottomNavigationProvider navigationProvider) async {
  try {
    await userService.logout();
    userService.setCurrentUserNull();
    navigationProvider.setCurrentIndex(0); // Reset to first tab
    CustomSnackbar.showSuccess(
      context: context,
      message: 'Logout successful!',
    );
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteManager.loginPage,
      (Route<dynamic> route) => false,
    );
  } catch (e) {
    CustomSnackbar.showError(
      context: context,
      message: getHumanReadableError(e.toString()),
    );
  }
}

void forgetPasswordInUI(BuildContext context, {required String email}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  if (email.isEmpty) {
    CustomSnackbar.showError(
      context: context,
      message: 'Please enter your email address!',
    );
    return;
  }

  // Validate email
  String? emailError = Validators.validateEmail(email);
  if (emailError != null) {
    CustomSnackbar.showError(
      context: context,
      message: emailError,
    );
    return;
  }

  try {
    final userService = Provider.of<UserViewModel>(context, listen: false);
    await userService.sendPasswordResetEmail(email);
    CustomSnackbar.showSuccess(
      context: context,
      message: 'Password reset email sent successfully!',
    );
  } catch (e) {
    CustomSnackbar.showError(
      context: context,
      message: getHumanReadableError(e.toString()),
    );
  }
}

void deleteUserAccountInUI(BuildContext context, UserViewModel userService,
    BottomNavigationProvider navigationProvider) async {
  // Show confirmation dialog before proceeding
  bool confirmDeletion = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () =>
                Navigator.of(context).pop(false), // User disagrees to delete
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () =>
                Navigator.of(context).pop(true), // User confirms deletion
          ),
        ],
      );
    },
  );

  if (confirmDeletion == true) {
    try {
      await userService.deleteUserAccount();
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Your account has been successfully deleted.')),
      );
      // If successful, reset navigation and go to login screen
      Future.delayed(const Duration(seconds: 2), () {
        navigationProvider.setCurrentIndex(0);
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.loginPage,
          (Route<dynamic> route) => false,
        );
      });
    } on RequiresReauthException {
      // Handle re-authentication requirement
      await showReauthenticationDialog(
          context, userService, navigationProvider);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: ${e.toString()}')),
      );
    }
  }
}

Future<void> showReauthenticationDialog(
    BuildContext context,
    UserViewModel userService,
    BottomNavigationProvider navigationProvider) async {
  String password = '';
  bool? result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Re-authenticate'),
      content: TextField(
        obscureText: true,
        onChanged: (value) => password = value,
        decoration: const InputDecoration(hintText: "Enter your password"),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('Confirm'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );

  if (result == true) {
    try {
      await userService.reauthenticateUser(
          userService.currentUser!.email!, password);
      // If re-authentication is successful, try deleting the account again
      await userService.deleteUserAccount();
      // If successful, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Your account has been successfully deleted.')),
      );
      // Reset navigation and go to login screen after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        navigationProvider.setCurrentIndex(0);
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.loginPage,
          (Route<dynamic> route) => false,
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: ${e.toString()}')),
      );
    }
  }
}

// This function is used to convert Firebase error messages to human-readable messages
String getHumanReadableError(String message) {
  if (message.contains('email address must be confirmed first')) {
    return 'Please check your inbox and confirm your email address and try to login again.';
  }
  if (message.contains('email address is already in use by another account')) {
    return 'This user already exists in our database. Please create a new user.';
  }
  if (message.contains('firebase_auth/invalid-credential')) {
    return 'Please check your username or password. The combination does not match any entry in our database.';
  }
  if (message.contains('The email address is badly formatted.')) {
    return 'Your account has been disabled. Please contact support.';
  }
  if (message
      .contains('There is no user record corresponding to this identifier.')) {
    return 'Your email address does not exist in our database. Please check for spelling mistakes.';
  }
  if (message.contains(
      'A network error (such as timeout, interrupted connection or unreachable host) has occurred.')) {
    return 'It seems as if you do not have an internet connection. Please connect and try again.';
  }
  return message;
}
