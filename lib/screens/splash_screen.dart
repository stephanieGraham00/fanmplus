import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _rotateAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.rose, Color(0xFFD8B4FE), AppTheme.lavender],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: AnimatedBuilder(
                animation: _rotateAnimation,
                builder: (_, child) => Transform.rotate(
                  angle: _rotateAnimation.value,
                  child: child,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Kawaii logo drawn with CustomPaint
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CustomPaint(
                        painter: _KawaiiLogoPainter(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Fanm+',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 4,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Espas an sekirite pou tout fanm',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        letterSpacing: 1,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Safe Space for Women',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      '❤️  💜  🌸  💫  🌺',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KawaiiLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFF9A8D4), Color(0xFFC084FC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bgPaint);

    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center.translate(0, 4), radius * 0.7, glowPaint);

    // Left eye
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(center.dx - radius * 0.35, center.dy - radius * 0.15), radius * 0.12, eyePaint);
    // Right eye
    canvas.drawCircle(Offset(center.dx + radius * 0.35, center.dy - radius * 0.15), radius * 0.12, eyePaint);

    // Pupils
    final pupilPaint = Paint()..color = const Color(0xFF4C1D95);
    canvas.drawCircle(Offset(center.dx - radius * 0.35, center.dy - radius * 0.15), radius * 0.06, pupilPaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.35, center.dy - radius * 0.15), radius * 0.06, pupilPaint);

    // Eye shine
    final shinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(center.dx - radius * 0.32, center.dy - radius * 0.19), radius * 0.035, shinePaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.38, center.dy - radius * 0.19), radius * 0.035, shinePaint);

    // Blush left
    final blushPaint = Paint()
      ..color = const Color(0xFFF472B6).withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(center.dx - radius * 0.55, center.dy + radius * 0.25), radius * 0.12, blushPaint);
    // Blush right
    canvas.drawCircle(Offset(center.dx + radius * 0.55, center.dy + radius * 0.25), radius * 0.12, blushPaint);

    // Smile
    final smilePath = Path()
      ..moveTo(center.dx - radius * 0.3, center.dy + radius * 0.3)
      ..quadraticBezierTo(center.dx, center.dy + radius * 0.65, center.dx + radius * 0.3, center.dy + radius * 0.3);
    final smilePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(smilePath, smilePaint);

    // Small flower on head
    _drawFlower(canvas, Offset(center.dx - radius * 0.1, center.dy - radius * 0.75), radius * 0.13);
    _drawFlower(canvas, Offset(center.dx + radius * 0.55, center.dy - radius * 0.55), radius * 0.09);

    // Sparkles
    final sparklePaint = Paint()..color = Colors.white.withOpacity(0.7);
    _drawStar(canvas, Offset(center.dx - radius * 0.7, center.dy - radius * 0.6), 4, sparklePaint);
    _drawStar(canvas, Offset(center.dx + radius * 0.75, center.dy - radius * 0.45), 3, sparklePaint);

    // Heart
    final heartPath = Path()
      ..moveTo(center.dx - radius * 0.08, center.dy + radius * 0.72)
      ..cubicTo(
        center.dx - radius * 0.18, center.dy + radius * 0.6,
        center.dx - radius * 0.25, center.dy + radius * 0.5,
        center.dx, center.dy + radius * 0.6,
      )
      ..cubicTo(
        center.dx + radius * 0.25, center.dy + radius * 0.5,
        center.dx + radius * 0.18, center.dy + radius * 0.6,
        center.dx + radius * 0.08, center.dy + radius * 0.72,
      );
    canvas.drawPath(heartPath, Paint()..color = const Color(0xFFFF6B9D));
  }

  void _drawFlower(Canvas canvas, Offset center, double r) {
    final petalPaint = Paint()..color = const Color(0xFFFDE68A);
    for (int i = 0; i < 5; i++) {
      final angle = i * 2 * math.pi / 5 - math.pi / 2;
      canvas.drawCircle(
        Offset(center.dx + r * 0.5 * math.cos(angle), center.dy + r * 0.5 * math.sin(angle)),
        r * 0.35,
        petalPaint,
      );
    }
    canvas.drawCircle(center, r * 0.2, Paint()..color = const Color(0xFFF59E0B));
    canvas.drawCircle(center, r * 0.1, Paint()..color = const Color(0xFFFBBF24));
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final a = i * math.pi / 2 - math.pi / 4;
      final x = center.dx + size * math.cos(a);
      final y = center.dy + size * math.sin(a);
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
