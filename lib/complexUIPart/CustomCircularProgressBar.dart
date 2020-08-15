import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCircleProgressBar extends StatefulWidget {
  final Color backColor, frontColor;
  final double size, strokeWidth, initialValue, currentValue, maxValue;
  final Duration animationDuration;
  final Image indicatorImage;

  const CustomCircleProgressBar(
      {Key key,
      this.backColor,
      this.frontColor,
      this.size,
      this.strokeWidth,
      this.currentValue,
      this.maxValue,
      this.animationDuration,
      this.initialValue,
      this.indicatorImage})
      : super(key: key);

  @override
  _CustomCircleProgressBarState createState() =>
      _CustomCircleProgressBarState();
}

class _CustomCircleProgressBarState extends State<CustomCircleProgressBar>
    with TickerProviderStateMixin {
  Animation<double> _valueAnimation;
  AnimationController _colorAnimationController;
  CurvedAnimation _animationCurve;

  @override
  void initState() {
    super.initState();
    _colorAnimationController =
        AnimationController(vsync: this, duration: widget.animationDuration);
    _colorAnimationController.addListener(() {
      setState(() {});
    });
    _animationCurve = new CurvedAnimation(
        parent: _colorAnimationController, curve: Curves.decelerate);
    _valueAnimation =
        Tween(begin: widget.initialValue, end: widget.currentValue)
            .animate(_animationCurve);
    onAnimationPlayed();
  }

  onAnimationPlayed() {
    _colorAnimationController.forward(from: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: MyProgressBarPainter(
          widget.strokeWidth,
          widget.backColor,
          widget.frontColor,
          widget.initialValue / widget.currentValue,
          _valueAnimation.value / widget.currentValue * 360,
          widget.currentValue / widget.maxValue * 360,
        ),
        size: Size(widget.size, widget.size),
        child: Center(
          child: widget.indicatorImage,
        ),
      ),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    onAnimationPlayed();
  }

  @override
  void dispose() {
    super.dispose();
    _colorAnimationController.dispose();
  }
}

class MyProgressBarPainter extends CustomPainter {
  var _drawBackgroundColor, _drawForeground;
  final _strokeWidth,
      _backgroundColor,
      _foregroundColor,
      _startAngle,
      _sweepAngle,
      _endAngle;

  MyProgressBarPainter(
      this._strokeWidth,
      this._backgroundColor,
      this._foregroundColor,
      this._startAngle,
      this._sweepAngle,
      this._endAngle) {
    _drawBackgroundColor = Paint()
      ..color = _backgroundColor
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    _drawForeground = Paint()
      ..color = _foregroundColor
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var radius = size.height > size.width ? size.height / 2 : size.width / 2;
    Rect rect = Rect.fromCircle(center: Offset(radius, radius), radius: radius);
    canvas.drawCircle(Offset(radius, radius), radius, _drawBackgroundColor);
    canvas.drawArc(
        rect, _startAngle / 180, _sweepAngle / 180, false, _drawForeground);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return _sweepAngle != _endAngle;
  }
}
