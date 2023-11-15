import 'package:flutter/material.dart';
import 'package:td_flutter/module/image_test/image_test_view.dart';

class CropRect extends CustomPainter{

  late Paint _bgPaint;
  late Paint _paint;
  late Paint _areaPaint;
  late Path _blackBGPath;
  late Path _cropPath;
  late Path _expandPath;
  double rectWidth;
  double rectHeight;
  final Offset offset;
  double expandRectWidth;
  ExpandRect? expandRect;

  CropRect(this.rectWidth,this.rectHeight,this.offset,this.expandRectWidth,{this.expandRect}){
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
    // canvas.translate(size.width / 2, size.height / 2);
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect blackBG = Rect.fromCenter(center: center, width: size.width, height: size.height);
    _blackBGPath.addRect(blackBG);
    double leftX = center.dx - rectWidth / 2 + offset.dx;
    double topY = center.dy - rectHeight / 2 + offset.dy;
    // print("leftX: $leftX, topY: $topY");
    // Rect cropRect = Rect.fromLTWH(leftX, topY, rectWidth, rectHeight);
    Rect cropRect;
    if(expandRect != null){
      switch(expandRect!){
        case ExpandRect.topLeft:
          cropRect = Rect.fromLTRB(
              center.dx - rectWidth / 2 + offset.dx, center.dy - rectHeight / 2 + offset.dy,
              center.dx + rectWidth / 2 + offset.dx, center.dy + rectHeight / 2 + offset.dy
          );
          // cropRect = rect!;
          print("left top !");
          break;
        case ExpandRect.topRight:
          cropRect = Rect.fromLTRB(
              center.dx - rectWidth / 2 + offset.dx, center.dy - rectHeight / 2 + offset.dy,
              center.dx + rectWidth / 2 + offset.dx, center.dy + rectHeight / 2 + offset.dy
          );
          break;
        case ExpandRect.bottomLeft:
          cropRect = Rect.fromLTRB(
              center.dx - rectWidth / 2 + offset.dx, center.dy - rectHeight / 2 + offset.dy,
              center.dx + rectWidth / 2 + offset.dx, center.dy + rectHeight / 2 + offset.dy
          );
          break;
        case ExpandRect.bottomRight:
          cropRect = Rect.fromLTRB(
              center.dx - rectWidth / 2 + offset.dx, center.dy - rectHeight / 2 + offset.dy,
              center.dx + rectWidth / 2 + offset.dx, center.dy + rectHeight / 2 + offset.dy
          );
          break;
      }
    }else{
      cropRect = Rect.fromLTRB(
          center.dx - rectWidth / 2 + offset.dx, center.dy - rectHeight / 2 + offset.dy,
          center.dx + rectWidth / 2 + offset.dx, center.dy + rectHeight / 2 + offset.dy
      );
      // cropRect = rect!;
    }
    _cropPath.addRect(cropRect);
    //透明背景
    canvas.drawPath(Path.combine(PathOperation.xor, _blackBGPath, _cropPath), _bgPaint);
    //裁剪框
    canvas.drawPath(_cropPath, _paint);
    //四个角的判定区域
    _drawTopLeft(canvas, leftX,topY);
  }

  void _drawTopLeft(Canvas canvas, double leftX,double topY){
    final halfExpandWidth = expandRectWidth / 2;
    final halfWidth = rectWidth / 2;
    // _expandPath.moveTo(center.dx, center.dy);
    final defaultLeft = leftX - halfExpandWidth;
    final defaultTop = topY - halfExpandWidth;
    Rect topLeftRect = Rect.fromLTWH(defaultLeft , defaultTop , expandRectWidth, expandRectWidth);
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
  bool shouldRepaint(covariant CropRect oldDelegate) {
    return oldDelegate.offset != offset || oldDelegate.rectWidth != rectWidth || oldDelegate.rectHeight != rectHeight
        // || oldDelegate.rect != rect;
    ;
  }

}