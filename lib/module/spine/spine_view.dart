import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spine_flutter/spine_flutter.dart';

import 'spine_logic.dart';

class SpinePage extends StatelessWidget {
  SpinePage({Key? key}) : super(key: key);

  static const dog1AnimNameList = [
    "dog_idle",
    "dog_idlean1",
    "dog_idlean2",
    //3脏了
    "dog_dirty",
    //4洗澡
    "dog_bath",
    //5口渴
    "dog_thirsty",
    //6喝水
    "dog_drinkwater",
    //7饿了
    "dog_hungry",
    //8吃东西
    "dog_eat",
    //9疲惫
    "dog_tired",
    //10开心
    "dog_caress"
  ];
  static List<String> get actionAnimNames => [dog1AnimNameList[1],dog1AnimNameList[2]];
  static List<String> get dog1IdleAnim => [dog1AnimNameList[0],dog1AnimNameList[3],dog1AnimNameList[5],dog1AnimNameList[7],dog1AnimNameList[9]];

  final logic = Get.put(SpineLogic());
  final state = Get.find<SpineLogic>().state;

  TrackEntry? initEntry;

  @override
  Widget build(BuildContext context) {
    reportLeaks();
    final controller = SpineWidgetController(onInitialized: (controller) {
      initEntry = controller.animationState.setAnimationByName(0, dog1IdleAnim[0], false);
    });
    return Scaffold(
        appBar: AppBar(title: const Text('Simple Animation')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: SpineWidget.fromAsset("assets/spine/dog1/dog1.atlas", "assets/spine/dog1/dog1.json", controller)),
              Wrap(
                children: [
                  ElevatedButton(onPressed: (){
                    // controller.animationStateData.setDefaultMix(0.5);
                    controller.animationStateData.setMixByName(dog1IdleAnim[0], actionAnimNames[0],0.5);
                    controller.animationState.setAnimationByName(0, dog1IdleAnim[0], true);
                    controller.animationState.addAnimationByName(0, actionAnimNames[0], false,0);
                  }, child: Text("mix")),
                  ElevatedButton(onPressed: (){
                    controller.animationState.setAnimationByName(0, dog1IdleAnim[0], false);
                  }, child: Text("待机")),
                  ElevatedButton(onPressed: (){
                    controller.animationState.setAnimationByName(0, dog1IdleAnim[0], true);
                  }, child: Text("待机循环")),
                  ElevatedButton(onPressed: () {
                    controller.animationState.addAnimationByName(0, actionAnimNames[0], false,0);
                  }, child: Text("交互1")),
                  ElevatedButton(onPressed: () {
                    controller.animationState.addAnimationByName(0, actionAnimNames[1], false,0);
                  }, child: Text("交互2")),
                  ElevatedButton(onPressed: ()=>
                      controller.animationState.addAnimationByName(0, "dog_dirty", true,0), child: const Text("脏了")),
                  ElevatedButton(onPressed: (){
                    controller.animationState.addAnimationByName(0, "dog_bath", false,0);
                    controller.animationState.addAnimationByName(0, dog1IdleAnim[0], true, 0);
                  }, child: Text("洗澡")),
                ],
              ),
            ],
          ),
        )
    );
  }
}
