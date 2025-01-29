import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Circle paint
    final circlePaint = Paint()
      ..color = Colors.amber.withOpacity(0.2)
      ..style = PaintingStyle.fill; // Fill the circle

    // Draw circles
    canvas.drawCircle(Offset(size.width / 2, size.height / 4), 50, circlePaint);
    canvas.drawCircle(
        Offset(size.width / 4, 3 * size.height / 4), 30, circlePaint);

    // Additional circles for creative pattern
    // Feel free to adjust the positions, sizes, and colors as desired
    final circlePaint2 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(3 * size.width / 4, size.height / 4), 40, circlePaint2);
    canvas.drawCircle(
        Offset(size.width / 2, 3 * size.height / 4), 60, circlePaint2);

    final circlePaint3 = Paint()
      ..color = Colors.red.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width / 4, size.height / 2), 20, circlePaint3);
    canvas.drawCircle(
        Offset(3 * size.width / 4, size.height / 2), 20, circlePaint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
