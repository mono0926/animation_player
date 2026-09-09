---
name: animation_player-animations
description: >-
  Use when embedding an interactive animation player widget with playback controls,
  scrubbing sliders, and duration indicators in Flutter apps or debug catalogs using animation_player.
---

# animation_player Animation Control Guide

`animation_player` provides a ready-to-use player widget containing play/pause controls, a seekable progress slider, and duration counters for debugging or presenting Flutter animations (such as `AnimatedIcon`, custom transitions, or Lottie/Rive animations).

## Guidelines

- **Mounting the Player**:
  - Wrap any animated widget inside `AnimationPlayer(builder: (context, animation) => ..., duration: Duration(...))`.
  - Pass the provided `Animation<double>` directly into widgets like `AnimatedIcon(progress: animation)` or custom `AnimatedBuilder` / `AnimatedWidget` implementations.
- **Configuring Durations**:
  - Specify `duration: const Duration(...)` according to the target animation's full cycle.
  - Set `autoReset: true` if the animation should immediately jump back to time 0 upon reaching completion.
- **Use Cases**:
  - Ideal for animation prototyping, widget catalog / Storybook showcases, design system review screens, and fine-tuning transition curves.

## Examples

### 1. Previewing AnimatedIcon Transitions

```dart
import 'package:animation_player/animation_player.dart';
import 'package:flutter/material.dart';

class AnimatedIconPreviewScreen extends StatelessWidget {
  const AnimatedIconPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animation Player Demo')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AnimationPlayer(
            duration: const Duration(milliseconds: 1500),
            autoReset: false,
            builder: (context, animation) {
              return AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: animation,
                size: 96,
                color: Theme.of(context).colorScheme.primary,
              );
            },
          ),
        ),
      ),
    );
  }
}
```

### 2. Custom Property Transition

```dart
import 'package:animation_player/animation_player.dart';
import 'package:flutter/material.dart';

class CustomCardTransition extends StatelessWidget {
  const CustomCardTransition({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimationPlayer(
      duration: const Duration(seconds: 2),
      builder: (context, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutBack,
        );

        return ScaleTransition(
          scale: curved,
          child: Card(
            elevation: 8,
            child: Container(
              width: 180,
              height: 180,
              alignment: Alignment.center,
              child: const Text('Interactive Card'),
            ),
          ),
        );
      },
    );
  }
}
```

## Common Pitfalls & Anti-Patterns

- ❌ **Anti-pattern**: Creating a separate `AnimationController` alongside `AnimationPlayer`.
  - ✔️ **Correct**: Rely entirely on the `animation` object passed to `builder`, which is managed and synchronized with the UI scrubber automatically.
