import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td_flutter/module/mindset_plus/touch_burst_flow.dart';

import 'mindset_plus_logic.dart';

class MindsetPlusPage extends StatelessWidget {
  MindsetPlusPage({Key? key}) : super(key: key);

  final logic = Get.put(MindsetPlusLogic());
  final state = Get.find<MindsetPlusLogic>().state;

  double iconSize = 50.0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          color: Colors.grey.withAlpha(66),
          alignment: Alignment.center,
          child: TouchBurstFlow(
            // menu: Icon(Icons.front_hand_outlined,size: iconSize,),
            menu: pressMenu(),
            // children: _buildIcons().map((e) => Container(
            //   color: Colors.grey,
            //   child: e,)).toList(),
            children: _buildChildren(6).map((e) => Container(
              color: Colors.grey,
              child: e,)).toList(),
          ),
        ),
      ),
    );
  }

  Widget pressMenu(){
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      clipBehavior: Clip.hardEdge,
      child: const ColoredBox(color: Colors.lightGreenAccent,child: Center(child: Text('按压并拖拽'))),
    );
  }

  List<Widget> _buildIcons(){
    return [
      Icon(Icons.add,color: Colors.white,size: iconSize),
      Icon(Icons.wallpaper,color: Colors.white,size: iconSize),
      Icon(Icons.message,color: Colors.white,size: iconSize),
      Icon(Icons.share,color: Colors.white,size: iconSize),
      Icon(Icons.home,color: Colors.white,size: iconSize),
      Icon(Icons.settings,color: Colors.white,size: iconSize),
    ];
  }

  List<Widget> _buildChildren(int count){
    List<Widget> list = [];
    for(int i = 0; i < count; i++){
      list.add(SizedBox(width: 50,height: 50,child: Center(child: Text('$i')),));
    }
    return list;
  }

}
