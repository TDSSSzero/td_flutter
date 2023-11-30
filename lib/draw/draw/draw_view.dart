import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td_flutter/draw/particle/world.dart';

import '../particle_clock/clock_panel.dart';
import '../particle_clock_bg/screen.dart';
import 'draw_logic.dart';

class DrawPage extends StatelessWidget {
  DrawPage({Key? key}) : super(key: key);

  final logic = Get.put(DrawLogic());
  final state = Get.find<DrawLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        // child: World(),
        // child: Screen(),
        child: ClockPanel(),
      ),
    );
  }
}
