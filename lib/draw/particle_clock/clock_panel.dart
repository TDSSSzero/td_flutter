import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:td_flutter/draw/particle_clock/bg_particle/bg_manage.dart';
import 'package:td_flutter/draw/particle_clock/clock_manage.dart';
import 'package:td_flutter/draw/particle_clock/clock_painter.dart';

import 'bg_particle/bg_particle_painter.dart';

/// author TDSSS
/// datetime 2023/11/30 17:57
///
class ClockPanel extends StatefulWidget {
  const ClockPanel({super.key});

  @override
  State<ClockPanel> createState() => _ClockPanelState();
}

class _ClockPanelState extends State<ClockPanel> with SingleTickerProviderStateMixin {

  late final Ticker _ticker;
  late ClockManage pm;
  late BgManage bm;

  @override
  void initState() {
    super.initState();
    pm = ClockManage(size: const Size(300, 150));
    pm.collectParticles(DateTime.now());
    bm = BgManage(size: const Size(300, 150));
    bm.checkParticles(DateTime.now());
    _ticker = createTicker(_tick)..start();
  }
  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        size: pm.size,
        painter: ClockPainter(pm),
        foregroundPainter: BgParticlePainter(manage: bm),
      );
  }


  void _tick(Duration duration){
    final now = DateTime.now();
    if(now.millisecondsSinceEpoch - pm.dateTime.millisecondsSinceEpoch > 100) {
      pm..dateTime = now..tick(now);
    }
    bm.tick(now);
  }
}
