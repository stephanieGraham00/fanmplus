import 'dart:math' as math;
import 'package:flutter/material.dart';

class FanmCat extends StatefulWidget {
  final double size;
  final bool bouncing;
  final String? message;
  final VoidCallback? onTap;

  const FanmCat({
    super.key,
    this.size = 80,
    this.bouncing = true,
    this.message,
    this.onTap,
  });

  @override
  State<FanmCat> createState() => _FanmCatState();
}

class _FanmCatState extends State<FanmCat> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _bounceAnim;
  late Animation<double> _tailAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _tailAnim = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _bounceAnim,
            builder: (_, child) => Transform.translate(
              offset: Offset(0, -widget.size * _bounceAnim.value),
              child: child,
            ),
            child: SizedBox(
              width: widget.size,
              height: widget.size * 0.85,
              child: CustomPaint(
                painter: _CatPainter(_tailAnim.value),
                size: Size(widget.size, widget.size * 0.85),
              ),
            ),
          ),
          if (widget.message != null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.message!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7B1FA2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CatPainter extends CustomPainter {
  final double tailSway;

  _CatPainter(this.tailSway);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final centerX = w / 2;
    final bodyTop = h * 0.25;
    final bodyBottom = h * 0.85;

    // Tail
    final tailPath = Path()
      ..moveTo(centerX - w * 0.25, bodyTop + h * 0.05)
      ..cubicTo(
        centerX - w * 0.45 + tailSway * w * 0.3,
        bodyTop - h * 0.1,
        centerX - w * 0.3 + tailSway * w * 0.5,
        bodyTop - h * 0.25,
        centerX - w * 0.2 + tailSway * w * 0.4,
        bodyTop - h * 0.15,
      );
    canvas.drawPath(
      tailPath,
      Paint()
        ..color = const Color(0xFFE1BEE7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.06
        ..strokeCap = StrokeCap.round,
    );

    // Body
    final bodyPaint = Paint()..color = const Color(0xFFE1BEE7);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(centerX, bodyTop + h * 0.3), width: w * 0.65, height: h * 0.55),
      bodyPaint,
    );

    // Head
    canvas.drawCircle(Offset(centerX, bodyTop), w * 0.32, bodyPaint);

    // Ears
    _drawEar(canvas, Offset(centerX - w * 0.2, bodyTop - w * 0.15), w * 0.15, true);
    _drawEar(canvas, Offset(centerX + w * 0.2, bodyTop - w * 0.15), w * 0.15, false);
    _earInner(canvas, Offset(centerX - w * 0.2, bodyTop - w * 0.12), w * 0.08);
    _earInner(canvas, Offset(centerX + w * 0.2, bodyTop - w * 0.12), w * 0.08);

    // Eyes
    _drawEye(canvas, Offset(centerX - w * 0.1, bodyTop + w * 0.02), w * 0.06);
    _drawEye(canvas, Offset(centerX + w * 0.1, bodyTop + w * 0.02), w * 0.06);

    // Nose
    final nosePath = Path()
      ..moveTo(centerX, bodyTop + w * 0.08)
      ..lineTo(centerX - w * 0.025, bodyTop + w * 0.12)
      ..lineTo(centerX + w * 0.025, bodyTop + w * 0.12)
      ..close();
    canvas.drawPath(nosePath, Paint()..color = const Color(0xFFF48FB1));

    // Mouth
    final mouthPaint = Paint()
      ..color = const Color(0xFFE91E63)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final mouthPath = Path()
      ..moveTo(centerX - w * 0.06, bodyTop + w * 0.13)
      ..quadraticBezierTo(centerX, bodyTop + w * 0.19, centerX + w * 0.06, bodyTop + w * 0.13);
    canvas.drawPath(mouthPath, mouthPaint);

    // Whiskers
    final whiskerPaint = Paint()
      ..color = Colors.grey.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 0; i < 3; i++) {
      final y = bodyTop + w * 0.07 + i * w * 0.03;
      canvas.drawLine(
        Offset(centerX - w * 0.08, y),
        Offset(centerX - w * 0.25, y - w * 0.02 + i * w * 0.02),
        whiskerPaint,
      );
      canvas.drawLine(
        Offset(centerX + w * 0.08, y),
        Offset(centerX + w * 0.25, y - w * 0.02 + i * w * 0.02),
        whiskerPaint,
      );
    }

    // Blush
    final blushPaint = Paint()
      ..color = const Color(0xFFF8BBD0).withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(centerX - w * 0.17, bodyTop + w * 0.07), w * 0.04, blushPaint);
    canvas.drawCircle(Offset(centerX + w * 0.17, bodyTop + w * 0.07), w * 0.04, blushPaint);

    // Paws
    final pawPaint = Paint()..color = const Color(0xFFF3E5F5);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(centerX - w * 0.12, bodyBottom), width: w * 0.1, height: w * 0.07),
      pawPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(centerX + w * 0.12, bodyBottom), width: w * 0.1, height: w * 0.07),
      pawPaint,
    );

    // Crown
    final crownPath = Path()
      ..moveTo(centerX - w * 0.12, bodyTop - w * 0.27)
      ..lineTo(centerX - w * 0.16, bodyTop - w * 0.4)
      ..lineTo(centerX - w * 0.08, bodyTop - w * 0.34)
      ..lineTo(centerX, bodyTop - w * 0.42)
      ..lineTo(centerX + w * 0.08, bodyTop - w * 0.34)
      ..lineTo(centerX + w * 0.16, bodyTop - w * 0.4)
      ..lineTo(centerX + w * 0.12, bodyTop - w * 0.27)
      ..close();
    canvas.drawPath(crownPath, Paint()..color = const Color(0xFFFFD700));
    canvas.drawCircle(Offset(centerX - w * 0.08, bodyTop - w * 0.36), w * 0.01, Paint()..color = const Color(0xFFFFF8E1));
    canvas.drawCircle(Offset(centerX, bodyTop - w * 0.39), w * 0.015, Paint()..color = const Color(0xFFFFF8E1));
    canvas.drawCircle(Offset(centerX + w * 0.08, bodyTop - w * 0.36), w * 0.01, Paint()..color = const Color(0xFFFFF8E1));
  }

  void _drawEar(Canvas canvas, Offset base, double size, bool left) {
    final earPath = Path()
      ..moveTo(base.dx - size * 0.5, base.dy + size * 0.3)
      ..lineTo(base.dx, base.dy - size * 0.7)
      ..lineTo(base.dx + size * 0.5, base.dy + size * 0.3)
      ..close();
    canvas.drawPath(earPath, Paint()..color = const Color(0xFFE1BEE7));
  }

  void _earInner(Canvas canvas, Offset base, double size) {
    final earPath = Path()
      ..moveTo(base.dx - size * 0.4, base.dy + size * 0.2)
      ..lineTo(base.dx, base.dy - size * 0.5)
      ..lineTo(base.dx + size * 0.4, base.dy + size * 0.2)
      ..close();
    canvas.drawPath(earPath, Paint()..color = const Color(0xFFF8BBD0));
  }

  void _drawEye(Canvas canvas, Offset center, double r) {
    canvas.drawCircle(center, r, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(center.dx + r * 0.1, center.dy + r * 0.1), r * 0.5, Paint()..color = const Color(0xFF4A148C));
    canvas.drawCircle(Offset(center.dx + r * 0.25, center.dy - r * 0.15), r * 0.2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_CatPainter old) => old.tailSway != tailSway;
}
