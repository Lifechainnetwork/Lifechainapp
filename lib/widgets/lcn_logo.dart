import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LCNLogoWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const LCNLogoWidget({
    super.key,
    this.size = 100.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final actualColor = color ?? AppTheme.primaryColor;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: LCNLogoPainter(color: actualColor),
      ),
    );
  }
}

class LCNLogoPainter extends CustomPainter {
  final Color color;

  LCNLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Draw circular background (soft red)
    final Paint backgroundPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), size.width * 0.48, backgroundPaint);

    // Draw LCN Text
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'LCN',
        style: TextStyle(
          color: color,
          fontSize: size.width * 0.28,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centerX - textPainter.width / 2,
        centerY - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
