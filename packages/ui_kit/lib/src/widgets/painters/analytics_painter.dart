// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';

class Analytics extends StatelessWidget {
  const Analytics({
    required this.color,
    this.size = const Size(32, 32),
    super.key,
  });
  final Color color;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: size, painter: AnalyticsPainter(color: color));
  }
}

class AnalyticsPainter extends CustomPainter {
  AnalyticsPainter({required this.color, super.repaint});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path_0 = Path();
    path_0.moveTo(size.width * 0.8333281, size.height * 0.6479781);
    path_0.cubicTo(
      size.width * 0.7844250,
      size.height * 0.8036813,
      size.width * 0.6389594,
      size.height * 0.9166250,
      size.width * 0.4671125,
      size.height * 0.9166250,
    );
    path_0.cubicTo(
      size.width * 0.2551547,
      size.height * 0.9166250,
      size.width * 0.08332813,
      size.height * 0.7448000,
      size.width * 0.08332813,
      size.height * 0.5328406,
    );
    path_0.cubicTo(
      size.width * 0.08332813,
      size.height * 0.3609969,
      size.width * 0.1962719,
      size.height * 0.2155303,
      size.width * 0.3519781,
      size.height * 0.1666259,
    );

    final Paint paint0Stroke =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.06250000;
    paint0Stroke.color = color;
    paint0Stroke.strokeCap = StrokeCap.round;
    canvas.drawPath(path_0, paint0Stroke);

    final Path path_1 = Path();
    path_1.moveTo(size.width * 0.9130406, size.height * 0.4145094);
    path_1.cubicTo(
      size.width * 0.8688094,
      size.height * 0.2560566,
      size.width * 0.7439781,
      size.height * 0.1312262,
      size.width * 0.5855250,
      size.height * 0.08699500,
    );
    path_1.cubicTo(
      size.width * 0.5170438,
      size.height * 0.06787812,
      size.width * 0.4583281,
      size.height * 0.1272984,
      size.width * 0.4583281,
      size.height * 0.1984000,
    );
    path_1.lineTo(size.width * 0.4583281, size.height * 0.4773375);
    path_1.cubicTo(
      size.width * 0.4583281,
      size.height * 0.5128875,
      size.width * 0.4871469,
      size.height * 0.5417062,
      size.width * 0.5226969,
      size.height * 0.5417062,
    );
    path_1.lineTo(size.width * 0.8016344, size.height * 0.5417062);
    path_1.cubicTo(
      size.width * 0.8727375,
      size.height * 0.5417062,
      size.width * 0.9321563,
      size.height * 0.4829937,
      size.width * 0.9130406,
      size.height * 0.4145094,
    );
    path_1.close();

    final Paint paint1Stroke =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.06250000;
    paint1Stroke.color = color;
    canvas.drawPath(path_1, paint1Stroke);

    final Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = color;
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
