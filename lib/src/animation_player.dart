import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef AnimationBuilder = Widget Function(
    BuildContext context, Animation<double> animation);

class AnimationPlayer extends StatefulWidget {
  const AnimationPlayer({
    Key key,
    @required this.builder,
  }) : super(key: key);

  final AnimationBuilder builder;

  @override
  _AnimationPlayerState createState() => _AnimationPlayerState();
}

class _AnimationPlayerState extends State<AnimationPlayer>
    with TickerProviderStateMixin {
  AnimationController _animation;
  AnimationController _animationForPlayButton;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _animationForPlayButton = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _animation.addListener(() {
      if (!_animation.isAnimating) {
        _animationForPlayButton.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animation.dispose();
    _animationForPlayButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTarget(),
        const SizedBox(height: 32),
        Row(
          children: [
            _buildPlayButton(),
            Expanded(
              child: _buildSlider(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTarget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1 / MediaQuery.of(context).devicePixelRatio,
        ),
      ),
      child: widget.builder(context, _animation),
    );
  }

  Widget _buildPlayButton() {
    return IconButton(
      iconSize: 44,
      icon: AnimatedIcon(
        color: Theme.of(context).accentColor,
        icon: AnimatedIcons.play_pause,
        progress: _animationForPlayButton,
      ),
      onPressed: () {
        if (_animation.isAnimating) {
          _animation.stop();
          _animationForPlayButton.reverse();
        } else {
          _animation.forward().then<void>((_) {
            _animation.reset();
            _animationForPlayButton.reverse();
          });
          _animationForPlayButton.forward();
        }
      },
    );
  }

  Widget _buildSlider() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) => Stack(
            overflow: Overflow.visible,
            children: [
              Positioned(
                top: -16,
                left: 16 + (constraints.maxWidth - 48) * _animation.value,
                child: Text(
                  NumberFormat.compact().format(_animation.value),
                ),
              ),
              Slider(
                value: _animation.value,
                onChanged: (value) => _animation.value = value,
              ),
            ],
          ),
        );
      },
    );
  }
}
