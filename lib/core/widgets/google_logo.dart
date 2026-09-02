import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;
  const GoogleLogo({super.key, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);
    final double radius = w / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.44;

    final rect = Rect.fromCircle(center: center, radius: radius * 0.78);

    // Red arc (top left to top right)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -3.14159 * 0.85, 3.14159 * 0.70, false, paint);

    // Yellow arc (bottom left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 3.14159 * 0.65, 3.14159 * 0.50, false, paint);

    // Green arc (bottom right)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 3.14159 * 0.15, 3.14159 * 0.50, false, paint);

    // Blue arc (right)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -3.14159 * 0.15, 3.14159 * 0.30, false, paint);

    // Blue horizontal bar
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final barRect = Rect.fromLTWH(
      center.dx,
      center.dy - (radius * 0.22),
      radius * 0.95,
      radius * 0.44,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(barRect, const Radius.circular(2)), barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
