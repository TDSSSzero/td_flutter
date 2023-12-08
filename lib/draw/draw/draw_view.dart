import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td_flutter/draw/particle/world.dart';

import '../particle_clock/clock_panel.dart';
import '../particle_clock_bg/screen.dart';
import 'draw_logic.dart';

class DrawPage extends StatefulWidget {
  DrawPage({Key? key}) : super(key: key);

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  final logic = Get.put(DrawLogic());

  final state = Get.find<DrawLogic>().state;

  Widget page = Container();

  final drawNames = {
    "粒子球" : World(),
    "粒子背景" : Screen(),
    "粒子时钟" : ClockPanel(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _buildEndDrawer(),
      endDrawerEnableOpenDragGesture: true,
      body: Container(
        color: const Color(0xFF9DFFCB),
        alignment: Alignment.center,
        // child: World(),
        // child: Screen(),
        child: page,
      ),
    );
  }

  Widget _buildEndDrawer(){
    return SafeArea(
        child: Drawer(
          width: 200,
          child: Padding(
              padding: EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: drawNames.length,
              itemBuilder : (_,index){
                return ElevatedButton(onPressed: (){
                  page = drawNames.values.toList()[index];
                  setState(() {});
                }, child: Text(drawNames.keys.toList()[index]));
              },
            ),
          ),
        )
    );
  }
}
