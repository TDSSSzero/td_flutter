import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:td_flutter/draw/particle/particle.dart';
import 'package:td_flutter/draw/particle/particle_manage.dart';

/// author TDSSS
/// datetime 2023/11/30 10:12
class WorldRender extends CustomPainter {

  late final ParticleManage manage;

  Paint fillPaint = Paint();

  Paint stokePaint = Paint()
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke;

  Paint rainPaint = Paint()
    ..colorFilter = const ColorFilter.matrix(<double>[
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 0.4, 0,
  ]);

  WorldRender({required this.manage}) : super(repaint: manage);

  @override
  void paint(Canvas canvas, Size size) {
    // _drawBallParticles(canvas, size);
    _drawRainParticles(canvas, size);
  }

  void drawParticle(Canvas canvas, Particle particle) {
    fillPaint.color = particle.color;
    canvas.drawCircle(Offset(particle.x, particle.y), particle.size, fillPaint);
  }

  void _drawBallParticles(Canvas canvas, Size size){
    canvas.drawRect(Offset.zero & size, stokePaint);
    for (var particle in manage.particles) {
      drawParticle(canvas, particle);
    }
  }

  void _drawRainParticles(Canvas canvas, Size size){
    if (manage.image == null) return;
    for (var particle in manage.particles) {
      rainPaint.color = particle.color;
      canvas.save();
      canvas.translate(particle.x, particle.y);
      var dis = sqrt(particle.vy * particle.vy + particle.vx * particle.vx);
      canvas.rotate(acos(particle.vx / dis) + pi + pi / 2);
      canvas.drawImageRect(
          manage.image!,
          Rect.fromLTWH(  0, 0, manage.image!.width * 1.0, manage.image!.height * 1.0),
          Rect.fromLTWH(  0, 0, manage.image!.width * 0.18, manage.image!.height * 0.18),
          rainPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant WorldRender oldDelegate) =>
      oldDelegate.manage != manage;

}