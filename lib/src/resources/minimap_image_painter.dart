import 'dart:ui' as ui;
import 'package:flutter/material.dart';
/// A custom painter that paints an image on a canvas.
class ImagePainter extends CustomPainter {
  final ui.Image image;
  final double miniWidth;
  final double miniHeight;

  ImagePainter(this.image, this.miniWidth, this.miniHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..filterQuality = FilterQuality.low;
    
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, miniWidth, miniHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) {
    return true;
  }
}
