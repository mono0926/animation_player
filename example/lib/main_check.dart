import 'dart:math';

import 'package:animation_player/animation_player.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const App());

class const App({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _Home(),
    );
  }
}

class const _Home() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimationPlayer example'),
      ),
      body: SafeArea(
        child: AnimationPlayer(
          duration: const Duration(milliseconds: 400),
          builder: (context, animation) => AnimatedBuilder(
            animation: animation.drive(CurveTween(curve: Curves.easeInOut)),
            builder: (context, child) => AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: CustomPaint(
                  painter: _Check(progress: animation.value),
                  child: child,
                ),
              ),
            ),
            //            child: SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _Check({
  required final double progress,
}) extends CustomPainter {
  this : super();
  final _paint = Paint()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  final _colorTween = ColorTween(
    begin: const Color(0xFF747474),
    end: const Color(0xFF4D85F3),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    _paint
      ..strokeWidth = radius / 10
      ..color = _colorTween.transform(progress)!;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      2 * pi * max(0, 1 - progress * 2),
      false,
      _paint,
    );

    const lineRatio = 3;
    final lineStartY = radius;
    final path = Path()..moveTo(0, lineStartY);
    final firstLineProgress = min(1, progress * lineRatio);
    final firstLineX = radius * 0.6 * firstLineProgress;
    final firstLineY = lineStartY + radius * 0.5 * firstLineProgress;
    path.lineTo(
      firstLineX,
      firstLineY,
    );
    if (firstLineProgress == 1) {
      final secondLineProgress =
          (progress - 1 / lineRatio) / (1 - 1 / lineRatio);
      path.lineTo(
        firstLineX + radius * 1.2 * secondLineProgress,
        firstLineY - radius * 1.3 * secondLineProgress,
      );
    }
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(_Check oldDelegate) => oldDelegate.progress != progress;
}
