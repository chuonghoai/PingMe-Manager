import 'package:flutter/material.dart';

class EventMarkerPainter extends CustomPainter {
  final String emoji;
  final Color pinColor;

  EventMarkerPainter({required this.emoji, this.pinColor = Colors.amber});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final radius = size.width / 2;

    final pinPath = Path();
    pinPath.moveTo(radius, size.height);
    pinPath.lineTo(radius * 0.6, radius * 1.4);
    pinPath.lineTo(radius * 1.4, radius * 1.4);
    pinPath.close();
    paint.color = pinColor;
    canvas.drawPath(pinPath, paint);

    canvas.drawCircle(Offset(radius, radius), radius, paint);

    paint.color = Colors.white;
    canvas.drawCircle(Offset(radius, radius), radius * 0.75, paint);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: emoji,
      style: TextStyle(fontSize: radius * 1.1),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
