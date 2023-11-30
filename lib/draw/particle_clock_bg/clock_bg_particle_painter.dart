import 'package:flutter/material.dart';

import 'clock_fx.dart';

/// author TDSSS
/// datetime 2023/11/30 12:16
class ClockBgParticlePainter extends CustomPainter{

  ClockFx fx;
  ClockBgParticlePainter({required this.fx}) : super(repaint: fx);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    for (var p in fx.particles) {
      var pos = Offset(p.x, p.y);
      var paint = Paint()
        ..color = p.color.withAlpha((255 * p.a).floor())
      ..strokeWidth = p.size * .2
      ..style = p.isFilled ? PaintingStyle.fill : PaintingStyle.stroke;
      if(p.isFilled){
        var rect = Rect.fromCenter(center: pos, width: p.size, height: p.size);
        canvas.drawRect(rect, paint);
      }else{
        canvas.drawCircle(pos, p.size / 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ClockBgParticlePainter oldDelegate) => false;

}