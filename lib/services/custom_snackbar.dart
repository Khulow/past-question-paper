import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    bool isError = false,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Flushbar(
        title: title,
        message: message,
        duration: duration,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        icon: Icon(
          isError ? Icons.error : Icons.info,
          color: Colors.white,
        ),
        backgroundColor: isError ? Colors.black87 : Colors.green,
        flushbarPosition: FlushbarPosition.TOP,
        animationDuration: const Duration(milliseconds: 500),
        isDismissible: true,
      ).show(context);
    });
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
  }) {
    show(
      context: context,
      message: message,
      title: title ?? 'Success',
      isError: false,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    String? title,
  }) {
    show(
      context: context,
      message: message,
      title: title ?? 'Error',
      isError: true,
    );
  }
}
