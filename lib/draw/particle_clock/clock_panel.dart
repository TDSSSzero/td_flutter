import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:td_flutter/draw/particle_clock/clock_manage.dart';
import 'package:td_flutter/draw/particle_clock/clock_painter.dart';

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

  @override
  void initState() {
    super.initState();
    pm = ClockManage(size: const Size(300, 150));
    pm.collectParticles();
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
    );
  }


  void _tick(Duration duration){
    if(DateTime.now().second % 1 == 0) pm.tick(DateTime.now());
  }
}
