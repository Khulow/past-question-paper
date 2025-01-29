import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    duration: const Duration(milliseconds: 2500),
    elevation: 10,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(5),
      topRight: Radius.circular(5),
    )),
    backgroundColor: Colors.transparent, // Set background color to transparent
    content: AwesomeSnackbarContent(
      //title: 'Notification',
      message: message,
      contentType: ContentType.failure
          , title: '', // You can use other types like ContentType.failure, ContentType.help, etc.
    ),
    behavior: SnackBarBehavior.floating, // To make the snackbar floating
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
