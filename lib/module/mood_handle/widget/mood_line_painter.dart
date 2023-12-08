import 'package:flutter/material.dart';

/// author TDSSS
/// datetime 2023/12/8 18:39
class MoodLinePainter extends CustomPainter{

  final Offset initOffset;
  Offset endOffset = Offset.zero;
  late Paint _paint;
  final List<Offset> offsets;

  MoodLinePainter(this.initOffset,this.endOffset,this.offsets){
    _paint = Paint()
    ..strokeWidth = 5
    ..color = Colors.red;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(initOffset, endOffset, _paint);
    for(var o in offsets){
      canvas.drawRect(Rect.fromLTWH(o.dx, o.dy, 50, 50), _paint);
    }
  }

  @override
  bool shouldRepaint(covariant MoodLinePainter oldDelegate) => endOffset != oldDelegate.endOffset;

}