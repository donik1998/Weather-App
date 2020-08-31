import 'package:flutter/material.dart';
import 'package:how_is_my_weather/complexUIPart/CloudAnimation.dart';
import 'package:how_is_my_weather/complexUIPart/CustomShapeClippers.dart';

class RainAnimation extends StatefulWidget {
  final Size rainDropSize, animationBoxSize;
  final Color cloudColor, rainDropColor;
  final double horizontalDropsOffset;
  final AnimationController controller;

  const RainAnimation(
      {Key key,
      @required this.rainDropSize,
      @required this.animationBoxSize,
      this.cloudColor,
      this.rainDropColor,
      @required this.horizontalDropsOffset,
      @required this.controller})
      : super(key: key);

  @override
  _RainAnimationState createState() => _RainAnimationState();
}

class _RainAnimationState extends State<RainAnimation>
    with TickerProviderStateMixin {
  AnimationController _animationController, _delayedAnimationController;
  CurvedAnimation _curvedAnimation, _delayedCurvedAnimation;
  Animation<Offset> _animation, _delayedAnimation;
  Animation<double> _animationOpacity, _delayedAnimationOpacity;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(TickerProvider: this, duration: Duration(seconds: 1));
    _delayedAnimationController =
        AnimationController(TickerProvider: this, duration: Duration(seconds: 1));
    _delayedAnimationController.addListener(() {
      if (_delayedAnimation.isCompleted) {
        _animationController.forward(from: 0);
      }
    });
    _animationController.addListener(() {
      if (_animation.isCompleted) {
        _delayedAnimationController.forward(from: 0);
      }
    });
    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);
    _delayedCurvedAnimation = CurvedAnimation(
        parent: _delayedAnimationController, curve: Curves.linear);
    _animation = Tween<Offset>(begin: Offset.zero, end: Offset(0, 0.8))
        .animate(_curvedAnimation);
    _delayedAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, 0.8))
        .animate(_delayedCurvedAnimation);
    _animationOpacity =
        Tween<double>(begin: 1.0, end: 0).animate(_animationController);
    _delayedAnimationOpacity =
        Tween<double>(begin: 1.0, end: 0).animate(_delayedAnimationController);
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.animationBoxSize.height,
      width: widget.animationBoxSize.width,
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Positioned(
            top: 60.0,
            left: widget.horizontalDropsOffset * 0 + 5.0,
            child: FadeTransition(
              opacity: _animationOpacity,
              child: SlideTransition(
                position: _animation,
                child: ClipPath(
                  clipBehavior: Clip.antiAlias,
                  clipper: RainDropShapeClipper(),
                  child: Container(
                    height: widget.rainDropSize.height,
                    width: widget.rainDropSize.width,
                    color: widget.rainDropColor == null
                        ? Colors.blueAccent.shade200
                        : widget.rainDropColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 60.0,
            left: widget.horizontalDropsOffset * 1 + 5.0,
            child: FadeTransition(
              opacity: _delayedAnimationOpacity,
              child: SlideTransition(
                position: _delayedAnimation,
                child: ClipPath(
                  clipBehavior: Clip.antiAlias,
                  clipper: RainDropShapeClipper(),
                  child: Container(
                    height: widget.rainDropSize.height,
                    width: widget.rainDropSize.width,
                    color: widget.rainDropColor == null
                        ? Colors.blueAccent.shade200
                        : widget.rainDropColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 60.0,
            left: widget.horizontalDropsOffset * 2 + 5.0,
            child: FadeTransition(
              opacity: _animationOpacity,
              child: SlideTransition(
                position: _animation,
                child: ClipPath(
                  clipBehavior: Clip.antiAlias,
                  clipper: RainDropShapeClipper(),
                  child: Container(
                    height: widget.rainDropSize.height,
                    width: widget.rainDropSize.width,
                    color: widget.rainDropColor == null
                        ? Colors.blueAccent.shade200
                        : widget.rainDropColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 60.0,
            left: widget.horizontalDropsOffset * 3 + 5.0,
            child: FadeTransition(
              opacity: _delayedAnimationOpacity,
              child: SlideTransition(
                position: _delayedAnimation,
                child: ClipPath(
                  clipBehavior: Clip.antiAlias,
                  clipper: RainDropShapeClipper(),
                  child: Container(
                    height: widget.rainDropSize.height,
                    width: widget.rainDropSize.width,
                    color: widget.rainDropColor == null
                        ? Colors.blueAccent.shade200
                        : widget.rainDropColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: CloudAnimation(
              clipAnimationController: widget.controller,
              boxSize: Size(100.0, 100.0),
              animationDuration: Duration(seconds: 2),
              clipColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _delayedAnimationController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
