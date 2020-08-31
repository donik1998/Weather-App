import 'package:flutter/material.dart';

class RotationAnimation extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;

  const RotationAnimation(
      {Key key, @required this.child, @required this.animationDuration})
      : super(key: key);

  @override
  _RotationAnimationState createState() => _RotationAnimationState();
}

class _RotationAnimationState extends State<RotationAnimation>
    with TickerProviderStateMixin {
  AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController =
        AnimationController(duration: widget.animationDuration, TickerProvider: this)
          ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      child: widget.child,
      alignment: Alignment.center,
      turns: _rotationController,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _rotationController.dispose();
  }
}
