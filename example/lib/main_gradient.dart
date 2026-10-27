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

class const Sky({
  required final double radius,
}) extends CustomPainter {
  this : super();
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = RadialGradient(
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
