import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:how_is_my_weather/complexUIPart/RotationAnimation.dart';

class TesterWidget extends StatefulWidget {
  @override
  _TesterWidgetState createState() => _TesterWidgetState();
}

class _TesterWidgetState extends State<TesterWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  Tween _animationTween;
  Path _path;
  Widget _animationChild;

  @override
  void initState() {
    super.initState();
    _animationChild = Container(
      child: RotationAnimation(
        animationDuration: Duration(seconds: 10),
        child: Image.asset(
          'assets/images/sun.png',
          height: 50.0,
        ),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            spreadRadius: 10.0,
            blurRadius: 10.0,
            offset: Offset.zero,
            color: Colors.yellow.shade900,
          )
        ],
      ),
    );
    _controller = AnimationController(
      vsync: this,
      duration: Duration(hours: 1),
    )..repeat();
    _animationTween = Tween(begin: 0.0, end: 1.0);
    _animation = _animationTween.animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.addListener(() {
      if (_animation.isCompleted) {
        _controller.animateBack(_animationTween.begin);
        setState(() {
          _animationChild = Container(
            child: RotationAnimation(
              animationDuration: Duration(seconds: 10),
              child: Image.asset(
                'assets/images/moon.png',
                height: 50.0,
              ),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  spreadRadius: 10.0,
                  blurRadius: 10.0,
                  offset: Offset.zero,
                  color: Colors.blueGrey.shade300,
                )
              ],
            ),
          );
        });
        Future.delayed(_controller.duration, () {
          setState(() {
            _animationChild = Container(
              child: RotationAnimation(
                animationDuration: Duration(seconds: 10),
                child: Image.asset(
                  'assets/images/sun.png',
                  height: 50.0,
                ),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    spreadRadius: 10.0,
                    blurRadius: 10.0,
                    offset: Offset.zero,
                    color: Colors.yellow.shade900,
                  )
                ],
              ),
            );
          });
          _controller.forward(from: 0.0);
        });
      }
    });
    _controller.forward();
    _path = drawPath(Size(300.0, 300.0));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tester Widget'),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Transform.translate(
                    offset: calculate(_animation.value),
                    child: Container(
                      child: _animationChild,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Path drawPath(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);
    return path;
  }

  Offset calculate(value) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
