import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td_flutter/module/flow_burst/burst_flow.dart';
import 'mindset_logic.dart';

class MindsetPage extends StatelessWidget {
  MindsetPage({Key? key}) : super(key: key);

  final logic = Get.put(MindsetLogic());
  final state = Get.find<MindsetLogic>().state;

  static const double iconSize = 50;


  final List<Icon> iconList = const [
    Icon(Icons.add,color: Colors.white,size: iconSize,),
    Icon(Icons.wallpaper,color: Colors.white,size: iconSize,),
    Icon(Icons.message,color: Colors.white,size: iconSize,),
    Icon(Icons.share,color: Colors.white,size: iconSize,),
    Icon(Icons.home,color: Colors.white,size: iconSize,),
    Icon(Icons.settings,color: Colors.white,size: iconSize,),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          color: Colors.grey.withAlpha(66),
          alignment: Alignment.center,
          child: BurstFlow(
            menu: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50))
              ),
              clipBehavior: Clip.hardEdge,
              child: const ColoredBox(color: Colors.greenAccent,child: Center(child: Text('点击'))),
            ),
          children: iconList,),
        ),
      ),
    );
  }
}
