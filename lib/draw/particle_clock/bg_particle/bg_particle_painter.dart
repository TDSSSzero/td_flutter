import 'package:flutter/material.dart';
import 'package:td_flutter/draw/particle_clock/bg_particle/bg_manage.dart';

import '../particle.dart';

/// author TDSSS
/// datetime 2023/12/1 10:32
class BgParticlePainter extends CustomPainter{

  final BgManage manage;
  final particlePaint = Paint();

  BgParticlePainter({required this.manage}) : super(repaint: manage);

  @override
  void paint(Canvas canvas, Size size) {
    if(manage.particles.isEmpty) return;
    for (var p in manage.particles) {
      canvas.drawCircle(Offset(p.x, p.y), p.size, particlePaint..color = p.color);
    }
  }

  @override
  bool shouldRepaint(covariant BgParticlePainter oldDelegate) => false;

}