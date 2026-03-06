// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';

class Agents extends StatelessWidget {
  const Agents({required this.color, super.key});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(32, 32),
      painter: AgentsPainter(color: color),
    );
  }
}

class AgentsPainter extends CustomPainter {
  AgentsPainter({required this.color, super.repaint});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint0Stroke =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.06250000;
    paint0Stroke.color = color;
    canvas.drawCircle(
      Offset(size.width * 0.4843750, size.height * 0.4218750),
      size.width * 0.1093750,
      paint0Stroke,
    );

    final Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = color;
    canvas.drawCircle(
      Offset(size.width * 0.4843750, size.height * 0.4218750),
      size.width * 0.1093750,
      paint0Fill,
    );

    final Path path_1 = Path();
    path_1.moveTo(size.width * 0.3371594, size.height * 0.7401313);
    path_1.lineTo(size.width * 0.3684094, size.height * 0.7401313);
    path_1.lineTo(size.width * 0.3684094, size.height * 0.7171563);
    path_1.lineTo(size.width * 0.3464813, size.height * 0.7103031);
    path_1.lineTo(size.width * 0.3371594, size.height * 0.7401313);
    path_1.close();
    path_1.moveTo(size.width * 0.7236844, size.height * 0.1433053);
    path_1.lineTo(size.width * 0.7432313, size.height * 0.1189225);
    path_1.lineTo(size.width * 0.7236844, size.height * 0.1433053);
    path_1.close();
    path_1.moveTo(size.width * 0.3371594, size.height * 0.9687500);
    path_1.lineTo(size.width * 0.3059081, size.height * 0.9687500);
    path_1.lineTo(size.width * 0.3059081, size.height);
    path_1.lineTo(size.width * 0.3371594, size.height);
    path_1.lineTo(size.width * 0.3371594, size.height * 0.9687500);
    path_1.close();
    path_1.moveTo(size.width * 0.7512625, size.height * 0.1677631);
    path_1.lineTo(size.width * 0.7825125, size.height * 0.1677631);
    path_1.lineTo(size.width * 0.7825125, size.height * 0.1546328);
    path_1.lineTo(size.width * 0.7731344, size.height * 0.1454431);
    path_1.lineTo(size.width * 0.7512625, size.height * 0.1677631);
    path_1.close();
    path_1.moveTo(size.width * 0.7512625, size.height * 0.2730263);
    path_1.lineTo(size.width * 0.7200125, size.height * 0.2730263);
    path_1.lineTo(size.width * 0.7200125, size.height * 0.2819603);
    path_1.lineTo(size.width * 0.7247344, size.height * 0.2895444);
    path_1.lineTo(size.width * 0.7512625, size.height * 0.2730263);
    path_1.close();
    path_1.moveTo(size.width * 0.9243406, size.height * 0.5509875);
    path_1.lineTo(size.width * 0.9247531, size.height * 0.5822344);
    path_1.lineTo(size.width * 0.9508688, size.height * 0.5344688);
    path_1.lineTo(size.width * 0.9243406, size.height * 0.5509875);
    path_1.close();
    path_1.moveTo(size.width * 0.7993406, size.height * 0.5526313);
    path_1.lineTo(size.width * 0.7989312, size.height * 0.5213844);
    path_1.lineTo(size.width * 0.7682281, size.height * 0.5217875);
    path_1.lineTo(size.width * 0.7680938, size.height * 0.5524938);
    path_1.lineTo(size.width * 0.7993406, size.height * 0.5526313);
    path_1.close();
    path_1.moveTo(size.width * 0.6414469, size.height * 0.7401313);
    path_1.lineTo(size.width * 0.6414469, size.height * 0.7088813);
    path_1.lineTo(size.width * 0.6101969, size.height * 0.7088813);
    path_1.lineTo(size.width * 0.6101969, size.height * 0.7401313);
    path_1.lineTo(size.width * 0.6414469, size.height * 0.7401313);
    path_1.close();
    path_1.moveTo(size.width * 0.6101969, size.height * 0.9062500);
    path_1.lineTo(size.width * 0.6101969, size.height * 0.9375000);
    path_1.lineTo(size.width * 0.6726969, size.height * 0.9375000);
    path_1.lineTo(size.width * 0.6726969, size.height * 0.9062500);
    path_1.lineTo(size.width * 0.6101969, size.height * 0.9062500);
    path_1.close();
    path_1.moveTo(size.width * 0.7985188, size.height * 0.7401313);
    path_1.lineTo(size.width * 0.7985188, size.height * 0.7713813);
    path_1.lineTo(size.width * 0.8297688, size.height * 0.7402688);
    path_1.lineTo(size.width * 0.7985188, size.height * 0.7401313);
    path_1.close();
    path_1.moveTo(size.width * 0.4934219, size.height);
    path_1.cubicTo(
      size.width * 0.5106812,
      size.height,
      size.width * 0.5246719,
      size.height * 0.9860094,
      size.width * 0.5246719,
      size.height * 0.9687500,
    );
    path_1.cubicTo(
      size.width * 0.5246719,
      size.height * 0.9514906,
      size.width * 0.5106812,
      size.height * 0.9375000,
      size.width * 0.4934219,
      size.height * 0.9375000,
    );
    path_1.lineTo(size.width * 0.4934219, size.height);
    path_1.close();
    path_1.moveTo(size.width * 0.1562500, size.height * 0.4309219);
    path_1.cubicTo(
      size.width * 0.1562500,
      size.height * 0.2447066,
      size.width * 0.3072066,
      size.height * 0.09375000,
      size.width * 0.4934219,
      size.height * 0.09375000,
    );
    path_1.lineTo(size.width * 0.4934219, size.height * 0.03125000);
    path_1.cubicTo(
      size.width * 0.2726887,
      size.height * 0.03125000,
      size.width * 0.09375000,
      size.height * 0.2101888,
      size.width * 0.09375000,
      size.height * 0.4309219,
    );
    path_1.lineTo(size.width * 0.1562500, size.height * 0.4309219);
    path_1.close();
    path_1.moveTo(size.width * 0.3464813, size.height * 0.7103031);
    path_1.cubicTo(
      size.width * 0.2417081,
      size.height * 0.6775594,
      size.width * 0.1562500,
      size.height * 0.5724969,
      size.width * 0.1562500,
      size.height * 0.4309219,
    );
    path_1.lineTo(size.width * 0.09375000, size.height * 0.4309219);
    path_1.cubicTo(
      size.width * 0.09375000,
      size.height * 0.5985750,
      size.width * 0.1957919,
      size.height * 0.7286906,
      size.width * 0.3278375,
      size.height * 0.7699594,
    );
    path_1.lineTo(size.width * 0.3464813, size.height * 0.7103031);
    path_1.close();
    path_1.moveTo(size.width * 0.4934219, size.height * 0.09375000);
    path_1.cubicTo(
      size.width * 0.5731875,
      size.height * 0.09375000,
      size.width * 0.6464094,
      size.height * 0.1214103,
      size.width * 0.7041375,
      size.height * 0.1676881,
    );
    path_1.lineTo(size.width * 0.7432313, size.height * 0.1189225);
    path_1.cubicTo(
      size.width * 0.6748125,
      size.height * 0.06407688,
      size.width * 0.5879062,
      size.height * 0.03125000,
      size.width * 0.4934219,
      size.height * 0.03125000,
    );
    path_1.lineTo(size.width * 0.4934219, size.height * 0.09375000);
    path_1.close();
    path_1.moveTo(size.width * 0.3059081, size.height * 0.7401313);
    path_1.lineTo(size.width * 0.3059081, size.height * 0.9687500);
    path_1.lineTo(size.width * 0.3684094, size.height * 0.9687500);
    path_1.lineTo(size.width * 0.3684094, size.height * 0.7401313);
    path_1.lineTo(size.width * 0.3059081, size.height * 0.7401313);
    path_1.close();
    path_1.moveTo(size.width * 0.7041375, size.height * 0.1676881);
    path_1.cubicTo(
      size.width * 0.7129250,
      size.height * 0.1747325,
      size.width * 0.7213531,
      size.height * 0.1822081,
      size.width * 0.7293906,
      size.height * 0.1900831,
    );
    path_1.lineTo(size.width * 0.7731344, size.height * 0.1454431);
    path_1.cubicTo(
      size.width * 0.7636188,
      size.height * 0.1361184,
      size.width * 0.7536375,
      size.height * 0.1272656,
      size.width * 0.7432313,
      size.height * 0.1189225,
    );
    path_1.lineTo(size.width * 0.7041375, size.height * 0.1676881);
    path_1.close();
    path_1.moveTo(size.width * 0.7200125, size.height * 0.1677631);
    path_1.lineTo(size.width * 0.7200125, size.height * 0.2730263);
    path_1.lineTo(size.width * 0.7825125, size.height * 0.2730263);
    path_1.lineTo(size.width * 0.7825125, size.height * 0.1677631);
    path_1.lineTo(size.width * 0.7200125, size.height * 0.1677631);
    path_1.close();
    path_1.moveTo(size.width * 0.7247344, size.height * 0.2895444);
    path_1.lineTo(size.width * 0.8978156, size.height * 0.5675062);
    path_1.lineTo(size.width * 0.9508688, size.height * 0.5344688);
    path_1.lineTo(size.width * 0.7777906, size.height * 0.2565081);
    path_1.lineTo(size.width * 0.7247344, size.height * 0.2895444);
    path_1.close();
    path_1.moveTo(size.width * 0.9239312, size.height * 0.5197406);
    path_1.lineTo(size.width * 0.7989312, size.height * 0.5213844);
    path_1.lineTo(size.width * 0.7997531, size.height * 0.5838781);
    path_1.lineTo(size.width * 0.9247531, size.height * 0.5822344);
    path_1.lineTo(size.width * 0.9239312, size.height * 0.5197406);
    path_1.close();
    path_1.moveTo(size.width * 0.6101969, size.height * 0.7401313);
    path_1.lineTo(size.width * 0.6101969, size.height * 0.9062500);
    path_1.lineTo(size.width * 0.6726969, size.height * 0.9062500);
    path_1.lineTo(size.width * 0.6726969, size.height * 0.7401313);
    path_1.lineTo(size.width * 0.6101969, size.height * 0.7401313);
    path_1.close();
    path_1.moveTo(size.width * 0.7680938, size.height * 0.5524938);
    path_1.lineTo(size.width * 0.7672688, size.height * 0.7399938);
    path_1.lineTo(size.width * 0.8297688, size.height * 0.7402688);
    path_1.lineTo(size.width * 0.8305906, size.height * 0.5527688);
    path_1.lineTo(size.width * 0.7680938, size.height * 0.5524938);
    path_1.close();
    path_1.moveTo(size.width * 0.7985188, size.height * 0.7088813);
    path_1.lineTo(size.width * 0.6414469, size.height * 0.7088813);
    path_1.lineTo(size.width * 0.6414469, size.height * 0.7713813);
    path_1.lineTo(size.width * 0.7985188, size.height * 0.7713813);
    path_1.lineTo(size.width * 0.7985188, size.height * 0.7088813);
    path_1.close();
    path_1.moveTo(size.width * 0.3371594, size.height);
    path_1.lineTo(size.width * 0.4934219, size.height);
    path_1.lineTo(size.width * 0.4934219, size.height * 0.9375000);
    path_1.lineTo(size.width * 0.3371594, size.height * 0.9375000);
    path_1.lineTo(size.width * 0.3371594, size.height);
    path_1.close();

    final Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = color;
    canvas.drawPath(path_1, paint1Fill);

    final Path path_2 = Path();
    path_2.moveTo(size.width * 0.4934094, size.height * 1.000053);
    path_2.lineTo(size.width * 0.4934094, size.height * 0.6563031);
    path_2.lineTo(size.width * 0.4755500, size.height * 0.6563031);
    path_2.cubicTo(
      size.width * 0.3473406,
      size.height * 0.6563031,
      size.width * 0.2434081,
      size.height * 0.5523687,
      size.width * 0.2434081,
      size.height * 0.4241594,
    );
    path_2.cubicTo(
      size.width * 0.2434081,
      size.height * 0.2959506,
      size.width * 0.3473406,
      size.height * 0.1920166,
      size.width * 0.4755500,
      size.height * 0.1920166,
    );
    path_2.lineTo(size.width * 0.4934094, size.height * 0.1920341);
    path_2.lineTo(size.width * 0.4934094, size.height * 0.06250000);

    final Paint paint2Stroke =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.06250000;
    paint2Stroke.color = color;
    canvas.drawPath(path_2, paint2Stroke);

    final Path path_3 = Path();
    path_3.moveTo(size.width * 0.5246594, size.height * 0.9696562);
    path_3.cubicTo(
      size.width * 0.5246656,
      size.height * 0.9693563,
      size.width * 0.5246719,
      size.height * 0.9690531,
      size.width * 0.5246719,
      size.height * 0.9687500,
    );
    path_3.cubicTo(
      size.width * 0.5246719,
      size.height * 0.9684469,
      size.width * 0.5246656,
      size.height * 0.9681437,
      size.width * 0.5246594,
      size.height * 0.9678438,
    );
    path_3.lineTo(size.width * 0.5246594, size.height * 0.6250531);
    path_3.lineTo(size.width * 0.4755500, size.height * 0.6250531);
    path_3.cubicTo(
      size.width * 0.3646000,
      size.height * 0.6250531,
      size.width * 0.2746581,
      size.height * 0.5351094,
      size.width * 0.2746581,
      size.height * 0.4241594,
    );
    path_3.cubicTo(
      size.width * 0.2746581,
      size.height * 0.3132156,
      size.width * 0.3645937,
      size.height * 0.2232747,
      size.width * 0.4755375,
      size.height * 0.2232666,
    );
    path_3.lineTo(size.width * 0.5246594, size.height * 0.2233147);
    path_3.lineTo(size.width * 0.5246594, size.height * 0.06340562);
    path_3.cubicTo(
      size.width * 0.5246656,
      size.height * 0.06310500,
      size.width * 0.5246719,
      size.height * 0.06280281,
      size.width * 0.5246719,
      size.height * 0.06250000,
    );
    path_3.cubicTo(
      size.width * 0.5246719,
      size.height * 0.04524125,
      size.width * 0.5106812,
      size.height * 0.03125000,
      size.width * 0.4934219,
      size.height * 0.03125000,
    );
    path_3.cubicTo(
      size.width * 0.2726887,
      size.height * 0.03125000,
      size.width * 0.09375000,
      size.height * 0.2101888,
      size.width * 0.09375000,
      size.height * 0.4309219,
    );
    path_3.cubicTo(
      size.width * 0.09375000,
      size.height * 0.5891719,
      size.width * 0.1846634,
      size.height * 0.7139719,
      size.width * 0.3059081,
      size.height * 0.7621844,
    );
    path_3.lineTo(size.width * 0.3059081, size.height);
    path_3.lineTo(size.width * 0.4621594, size.height);
    path_3.lineTo(size.width * 0.4621594, size.height * 1.000053);
    path_3.lineTo(size.width * 0.5246594, size.height * 1.000053);
    path_3.lineTo(size.width * 0.5246594, size.height * 0.9696562);
    path_3.close();

    final Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = color;
    canvas.drawPath(path_3, paint3Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
