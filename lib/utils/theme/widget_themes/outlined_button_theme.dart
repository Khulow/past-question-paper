import 'package:flutter/material.dart';
import 'package:past_question_paper/miscellaneous/constants/colors.dart';
import 'package:past_question_paper/miscellaneous/constants/sizes.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._(); //to avoid creting instances

//light theme for buttons
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(),
        foregroundColor: tPrimaryColor,
        //side: const BorderSide(color: tSecondaryColor),
        //use symmetric so that the button is reponsive
        padding: const EdgeInsets.symmetric(vertical: tButtonHeight)),
  );

//dark theme for buttons
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(),
        foregroundColor: tWhiteColor, //so that color contrast theme
        side: const BorderSide(color: tWhiteColor),
        //use symmetric so that the button is reponsive
        padding: const EdgeInsets.symmetric(vertical: tButtonHeight)),
  );
}
