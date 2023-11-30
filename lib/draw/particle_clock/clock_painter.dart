import 'package:flutter/cupertino.dart';
import 'package:td_flutter/draw/particle_clock/clock_manage.dart';

/// author TDSSS
/// datetime 2023/11/30 18:00
class ClockPainter extends CustomPainter{

  final ClockManage manage;
  Paint clockPaint = Paint();

  ClockPainter(this.manage) : super(repaint: manage);

  @override
  void paint(Canvas canvas, Size size) {
    if(manage.particles.isEmpty) return;
    for (var p in manage.particles) {
      clockPaint.color = p.color;
      canvas.drawCircle(Offset(p.x, p.y), p.size, clockPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) => true;

}