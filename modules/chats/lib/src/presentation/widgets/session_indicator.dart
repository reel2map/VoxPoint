import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class SessionIndicator extends StatefulWidget {
  const SessionIndicator({super.key});

  @override
  SessionIndicatorState createState() => SessionIndicatorState();
}

class SessionIndicatorState extends State<SessionIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  Color get mainOrange => const Color(0xFFFA8434);

  Color get mainOrange10 => const Color(0x1AFA8434);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.long3,
    );
    _colorTween = ColorTween(
      begin: mainOrange,
      end: mainOrange10,
    ).animate(_animationController)..addListener(changeColor);

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController
      ..stop()
      ..dispose();

    super.dispose();
  }

  void changeColor() {
    if (_animationController.value == _animationController.upperBound) {
      _animationController.reverse();
    }

    if (_animationController.value == _animationController.lowerBound) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder:
          (context, child) => Container(
            width: Insets.s,
            height: Insets.s,
            decoration: BoxDecoration(
              color: _colorTween.value,
              shape: BoxShape.circle,
            ),
          ),
    );
  }
}
