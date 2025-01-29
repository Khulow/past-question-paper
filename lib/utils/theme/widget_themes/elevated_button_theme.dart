import 'package:flutter/material.dart';
import 'package:past_question_paper/miscellaneous/constants/colors.dart';
import 'package:past_question_paper/miscellaneous/constants/sizes.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

//light theme for buttons
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      foregroundColor: Colors.white,
      backgroundColor: tPrimaryColor,
      //side: const BorderSide(color: tSecondaryColor),
      //use symmetric so that the button is reponsive
      padding: const EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );

//dark theme for buttons
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      foregroundColor: tPrimaryColor,
      backgroundColor: const Color.fromRGBO(103, 145, 199, 1),
      //side: const BorderSide(color: tSecondaryColor),
      //use symmetric so that the button is reponsive
      padding: const EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );
}
