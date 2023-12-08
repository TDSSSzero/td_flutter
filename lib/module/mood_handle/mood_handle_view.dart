import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td_flutter/module/mood_handle/widget/background_paper.dart';
import 'package:td_flutter/module/mood_handle/widget/mood_custom.dart';
import 'package:td_flutter/module/mood_handle/widget/mood_flow.dart';

import 'mood_handle_logic.dart';
import 'widget/mood_handle.dart';

class MoodHandlePage extends StatefulWidget {
  MoodHandlePage({Key? key}) : super(key: key);

  @override
  State<MoodHandlePage> createState() => _MoodHandlePageState();
}

class _MoodHandlePageState extends State<MoodHandlePage> {
  final logic = Get.put(MoodHandleLogic());

  final state = Get
      .find<MoodHandleLogic>()
      .state;

  bool isPlay = false;

  @override
  Widget build(BuildContext context) {
    double dpr = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: Stack(
        fit: StackFit.passthrough,
        children: [
          // Center(child: BackgroundPaper(width: 300,height: 500,padding: EdgeInsets.all(10),)),
          // Container(
          //   alignment: Alignment.center,
          //   child: MoodFlow(width: 300.0, height: 300.0,isPlay: isPlay,),
          // ),
          Container(
            alignment: Alignment.center,
            child: MoodCustom(width: 300.0, height: 300.0,isPlay: isPlay,),
          ),
          Positioned(
            bottom: 200,
              left: 200,
              child: ElevatedButton(onPressed: onTest,child: Text("test"),))
        ],
      ),
    );
  }

  void onTest(){
    isPlay = !isPlay;
    setState(() {

    });
  }
}
