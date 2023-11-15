import 'package:flutter/material.dart';

/// author TDSSS
/// datetime 2023/11/13 11:15
class CropRectPoint extends CustomPainter{

  late Paint _bgPaint;
  late Paint _paint;
  late Paint _areaPaint;
  late Path _blackBGPath;
  late Path _cropPath;
  late Path _expandPath;
  double expandRectSize;
  bool isShowExpandRect;
  Rect rect;

  CropRectPoint({required this.rect,this.isShowExpandRect = true,this.expandRectSize = 50.0}){
    _bgPaint = Paint()
      ..color = Colors.black87.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    _paint = Paint()
      ..color = Colors.amber.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    _areaPaint = Paint()
      ..color = Colors.red.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    _blackBGPath = Path();
    _cropPath = Path();
    _expandPath = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect blackBG = Rect.fromCenter(center: center, width: size.width, height: size.height);
    _blackBGPath.addRect(blackBG);
    _cropPath.addRect(rect);
    //透明背景
    canvas.drawPath(Path.combine(PathOperation.xor, _blackBGPath, _cropPath), _bgPaint);
    //裁剪框
    canvas.drawPath(_cropPath, _paint);
    //四个角的判定区域
    _drawTopLeft(canvas, rect);
  }

  void _drawTopLeft(Canvas canvas, Rect rect){
    Rect topLeftRect = Rect.fromCenter(center:rect.topLeft,width: expandRectSize, height: expandRectSize);
    final rectWidth = rect.width;
    final rectHeight = rect.height;
    _expandPath
      ..addRect(topLeftRect)
      ..relativeMoveTo(rectWidth, 0)
      ..addRect(topLeftRect.translate(rectWidth, 0))
      ..relativeMoveTo(0, rectHeight)
      ..addRect(topLeftRect.translate(0, rectHeight))
      ..relativeMoveTo(rectWidth, rectHeight)
      ..addRect(topLeftRect.translate(rectWidth, rectHeight))
    ;
    canvas.drawPath(_expandPath, _areaPaint);
  }

  @override
  bool shouldRepaint(covariant CropRectPoint oldDelegate) {
    return oldDelegate.rect != rect
        || oldDelegate.isShowExpandRect != isShowExpandRect
        || oldDelegate.expandRectSize != expandRectSize
    ;

  }

}