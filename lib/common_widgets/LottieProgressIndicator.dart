import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieProgressIndicator extends StatelessWidget {
  final String animationPath;
  final double width;
  final double height;

  const LottieProgressIndicator({
    super.key,
    required this.animationPath,
    this.width = 100.0,
    this.height = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        animationPath,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
