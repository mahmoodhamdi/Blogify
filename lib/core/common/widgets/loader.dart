import 'package:blogify/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  final double size;

  const Loader({super.key, this.size = 50.0});

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color1 =
        isDarkMode ? AppPalette.darkPrimary : AppPalette.lightPrimary;
    final color2 = isDarkMode ? AppPalette.darkAccent : AppPalette.lightAccent;

    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * 3.14,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _LoaderPainter(
                animation: _animation,
                color1: color1,
                color2: color2,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoaderPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color1;
  final Color color2;

  _LoaderPainter(
      {required this.animation, required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 10
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - paint.strokeWidth) / 2;

    // Draw the first arc
    paint.color = color1;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      animation.value * 3.14,
      false,
      paint,
    );

    // Draw the second arc
    paint.color = color2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14,
      animation.value * 3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
