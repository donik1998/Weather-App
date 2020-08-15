import 'package:flutter/material.dart';
import 'package:how_is_my_weather/complexUIPart/CustomShapeClippers.dart';

class CloudAnimation extends AnimatedWidget {
  final Duration animationDuration;
  final Size boxSize;
  final AnimationController clipAnimationController;
  final Color clipColor;
  CloudAnimation(
      {Key key,
      @required this.clipColor,
      @required this.clipAnimationController,
      @required this.animationDuration,
      @required this.boxSize})
      : super(listenable: clipAnimationController, key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: clipAnimationController,
      builder: (_, __) {
        return ClipPath(
          clipBehavior: Clip.antiAlias,
          clipper: AnimatedCloudShapeClipper(clipAnimationController.value),
          child: Container(
            width: boxSize.width,
            height: boxSize.height,
            color: clipColor,
          ),
        );
      },
    );
  }
}
