import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// author TDSSS
/// datetime 2023/11/10 15:55
class DrawCropImage extends CustomPainter{

  final ui.Image _image;
  final Rect cropRect;
  late Paint _paint;
  late Path path;

  DrawCropImage(this._image,this.cropRect) {
    _paint = Paint()
    ..style = PaintingStyle.fill;
    path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    print("image width : ${_image.width}, image height : ${_image.height}");
    print("cropRect.topLeft : ${cropRect.topLeft}, cropRect.topLeft : ${cropRect.topRight}");
    canvas.drawImageRect(_image, cropRect, Rect.fromCenter(center: Offset.zero, width: cropRect.width, height: cropRect.height), _paint);
  }

  @override
  bool shouldRepaint(covariant DrawCropImage oldDelegate) {
    return false;
  }
}