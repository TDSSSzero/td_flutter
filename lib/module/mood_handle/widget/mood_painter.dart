import 'package:flutter/material.dart';

/// author TDSSS
/// datetime 2023/12/8 19:42
class MoodPainter extends CustomPainter{

  final Offset initOffset;
  Offset endOffset = Offset.zero;
  late Paint _paint;
  final List<Offset> offsets;

  MoodPainter(this.initOffset,this.endOffset,this.offsets){
    _paint = Paint()
      ..strokeWidth = 5
      ..color = Colors.red;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2 - 50 / 2, size.height / 2 - 50 / 2);
    canvas.drawRect(Rect.fromLTWH(0, 0, 50, 50), _paint);

    canvas.drawLine(initOffset, endOffset, _paint);
    for(var o in offsets){
      canvas.drawRect(Rect.fromLTWH(o.dx, o.dy, 50, 50), _paint);
    }
  }

  @override
  bool shouldRepaint(covariant MoodPainter oldDelegate) => true;

}