import 'package:animation_player/animation_player.dart';
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _Home(),
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
          builder: (context, animation) => AnimatedBuilder(
            animation: animation,
            builder: (context, child) => AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: Sky(radius: animation.value),
                child: child,
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class Sky extends CustomPainter {
  const Sky({
    @required this.radius,
  }) : super();
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: radius,
      colors: const [Color(0xFFFF0000), Color(0xFFFFCCFF)],
      stops: const [0.2, 1],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(Sky oldDelegate) => oldDelegate.radius != radius;
}
