import 'package:flutter/material.dart';

class MindsetCropRect extends CustomPainter{

  late Paint _bgPaint;
  late Paint _paint;
  late Path _blackBGPath;
  late Path _cropPath;
  double rectWidth;
  double rectHeight;
  // final ValueNotifier<Offset> offset;
  final Offset offset;
  double expandRectWidth;

  MindsetCropRect(this.rectWidth,this.rectHeight,this.offset,this.expandRectWidth){
    _bgPaint = Paint()
    ..color = Colors.black87.withOpacity(0.7)
    ..style = PaintingStyle.fill;
    _paint = Paint()
      ..color = Colors.amber.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    _blackBGPath = Path();
    _cropPath = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.translate(size.width / 2, size.height / 2);
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect blackBG = Rect.fromCenter(center: center, width: size.width, height: size.height);
    _blackBGPath.addRect(blackBG);
    Rect cropRect = Rect.fromLTWH(center.dx - rectWidth / 2 + offset.dx, center.dy - rectHeight / 2 + offset.dy, rectWidth, rectHeight);
    // print("offset ${Offset(offset.dx,offset.dy)}");
    _cropPath.addRect(cropRect);
    canvas.drawPath(Path.combine(PathOperation.xor, _blackBGPath, _cropPath), _bgPaint);
    canvas.drawPath(_cropPath, _paint);
    canvas.drawRect(Rect.fromCenter(center: center, width: expandRectWidth, height: expandRectWidth), _paint);
  }

  @override
  bool shouldRepaint(covariant MindsetCropRect oldDelegate) {
    return oldDelegate.offset != offset;
  }

}