import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ImagePainter extends CustomPainter {
  final ui.Image image;
  final double miniWidth;
  final double miniHeight;

  ImagePainter(this.image, this.miniWidth, this.miniHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, miniWidth, image.height * 1.0),
      Rect.fromLTWH(0, 0, miniWidth, miniHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
