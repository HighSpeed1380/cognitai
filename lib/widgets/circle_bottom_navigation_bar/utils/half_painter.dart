import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math.dart';

/// Class [HalfPainter]
/// [paintColor]: paint Color
class HalfPainter extends CustomPainter {
  late Paint arcPaint;
  HalfPainter({
    required Color paintColor,
  }) {
    arcPaint = Paint()..color = paintColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final beforeRect = Rect.fromLTWH(0, (size.height / 2) - 10, 10, 10);
    final largeRect = Rect.fromLTWH(10, 0, size.width - 20, 70);

    final afterRect =
        Rect.fromLTWH(size.width - 10, (size.height / 2) - 10, 10, 10);

    final path = Path();
    path.arcTo(beforeRect, radians(0), radians(90), false);
    path.lineTo(20, size.height / 2);
    path.arcTo(largeRect, radians(0), -radians(180), false);
    path.moveTo(size.width - 10, size.height / 2);
    path.lineTo(size.width - 10, (size.height / 2) - 10);
    path.arcTo(afterRect, radians(180), radians(-90), false);
    path.close();

    canvas.drawPath(path, arcPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
