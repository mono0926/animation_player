import 'dart:math';

import 'package:animation_player/animation_player.dart';
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimationPlayer example'),
      ),
      body: SafeArea(
        child: AnimationPlayer(
          duration: Duration(milliseconds: 400),
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

class _Check extends CustomPainter {
  _Check({
    @required this.progress,
  }) : super();
  final double progress;

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
      ..color = _colorTween.transform(progress);

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
