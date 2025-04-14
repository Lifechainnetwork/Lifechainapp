import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_theme.dart';

class AnimatedLoadingIndicator extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const AnimatedLoadingIndicator({
    super.key,
    this.size = 50.0,
    this.color = AppTheme.primaryColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<AnimatedLoadingIndicator> createState() => _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<AnimatedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _radiusAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159, // 360 degrees in radians
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _radiusAnimation = Tween<double>(
      begin: widget.size * 0.2,
      end: widget.size * 0.4,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: LoadingIndicatorPainter(
              color: widget.color,
              rotationAngle: _rotationAnimation.value,
              radius: _radiusAnimation.value,
              dotRadius: widget.size * 0.08,
            ),
          ),
        );
      },
    );
  }
}

class LoadingIndicatorPainter extends CustomPainter {
  final Color color;
  final double rotationAngle;
  final double radius;
  final double dotRadius;

  LoadingIndicatorPainter({
    required this.color,
    required this.rotationAngle,
    required this.radius,
    required this.dotRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw 8 dots in a circle
    for (int i = 0; i < 8; i++) {
      final angle = rotationAngle + (i * 3.14159 * 2 / 8);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      
      // Make dots fade based on position
      final opacity = 0.3 + (0.7 * (i / 8));
      paint.color = color.withOpacity(opacity);
      
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(LoadingIndicatorPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.radius != radius;
  }
}
