import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_animation_builder/progress_animation_builder.dart';

typedef AnimationBuilder = Widget Function(
    BuildContext context, Animation<double> animation);

class AnimationPlayer extends StatefulWidget {
  const AnimationPlayer({
    Key key,
    @required this.builder,
    this.duration = const Duration(milliseconds: 2000),
    this.autoReset = false,
  }) : super(key: key);

  final AnimationBuilder builder;
  final Duration duration;
  final bool autoReset;

  @override
  _AnimationPlayerState createState() => _AnimationPlayerState();
}

class _AnimationPlayerState extends State<AnimationPlayer>
    with SingleTickerProviderStateMixin {
  AnimationController _animation;
  var _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation.addListener(() {
      if (!_animation.isAnimating) {
        togglePlayButton(isPlaying: false);
      }
    });
  }

  @override
  void dispose() {
    _animation.dispose();
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
      icon: ProgressAnimationBuilder(
        value: _isPlaying ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        builder: (context, animation) => AnimatedIcon(
          color: Theme.of(context).colorScheme.secondary,
          icon: AnimatedIcons.play_pause,
          progress: animation,
        ),
      ),
      onPressed: () {
        if (_animation.isAnimating) {
          _animation.stop();
          togglePlayButton(isPlaying: false);
        } else {
          _animation
              .forward(from: _animation.isCompleted ? 0 : null)
              .then<void>((_) {
            if (widget.autoReset) {
              _animation.reset();
              togglePlayButton(isPlaying: false);
            }
          });
          togglePlayButton(isPlaying: true);
        }
      },
    );
  }

  Widget _buildSlider() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                NumberFormat('0.00').format(_animation.value),
              ),
            ),
            Expanded(
              child: Slider(
                value: _animation.value,
                onChanged: (value) => _animation.value = value,
              ),
            ),
          ],
        );
      },
    );
  }

  void togglePlayButton({@required bool isPlaying}) {
    setState(() {
      _isPlaying = isPlaying;
    });
  }
}
