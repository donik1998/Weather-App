import 'dart:math';

import 'package:flutter/material.dart';

class CloudShapeClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double width = size.width;
    double height = size.height;

    final path = Path();
    path.moveTo(width * 0.25, height * 0.5);
    path.cubicTo(width * 0.3, height * 0.15, width * 0.7, height * 0.15,
        width * 0.75, height * 0.5);
    path.cubicTo(width * 0.85, height * 0.5, width * 0.9, height * 0.55,
        width * 0.85, height * 0.65);
    path.cubicTo(width, height * 0.65, width, height * 0.85, width * 0.85,
        height * 0.85);
    path.lineTo(width * 0.25, height * 0.85);
    path.cubicTo(width * 0.0, height * 0.85, width * 0.0, height * 0.55,
        width * 0.25, height * 0.5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}

class AnimatedCloudShapeClipper extends CustomClipper<Path> {
  double changeFactor;
  AnimatedCloudShapeClipper(this.changeFactor);

  @override
  getClip(Size size) {
    double width = size.width;
    double height = size.height;

    final path = Path();
    path.moveTo(width * cos(changeFactor) * 0.25, height * 0.5);
    path.cubicTo(
        width * 0.3,
        height * cos(changeFactor) * 0.15,
        width * 0.7,
        height * cos(changeFactor) * 0.15,
        width * cos(changeFactor) * 0.75,
        height * cos(changeFactor / 2) * 0.5);
    path.cubicTo(
        width * 0.85,
        height * cos(changeFactor) * 0.5,
        width * cos(changeFactor) * 0.9,
        height * 0.55,
        width * 0.85,
        height * cos(changeFactor) * 0.65);
    path.cubicTo(width, height * cos(changeFactor) * 0.65, width, height * 0.85,
        width * 0.85, height * 0.85);
    path.lineTo(width * cos(changeFactor) * 0.25, height * 0.85);
    path.cubicTo(width * 0.0, height * 0.85, width * 0.0, height * 0.55,
        width * 0.25, height * cos(changeFactor * 0.9) * 0.5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

//class ReversedCloudClipper extends CustomClipper<Path> {
//  @override
//  getClip(Size size) {
//    final path = Path();
//
//    return path;
//  }
//
//  @override
//  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
//}

class RainDropShapeClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double width = size.width;
    double height = size.height;
    final path = Path();
    path.moveTo(width * 0.5, height * 0);
    path.lineTo(width * 0.6, height * 0.3);
    path.quadraticBezierTo(
        width * 0.5, height * 0.6, width * 0.4, height * 0.3);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
