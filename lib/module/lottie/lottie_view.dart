import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'lottie_logic.dart';

class LottiePage extends StatelessWidget {
  LottiePage({Key? key}) : super(key: key);

  final logic = Get.put(LottieLogic());
  final state = Get.find<LottieLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Obx(() => Lottie.asset(
            logic.lottiePath.value,
            frameRate: FrameRate.max,
            controller: logic.controller,
            onLoaded: (lottieComposition) {
              logic.onAnimLoaded(lottieComposition);
            },
          )),
          Lottie.asset(
            logic.introOpen1Idle,
            frameRate: FrameRate.max,
            height: 1,
            width: 1
          )
        ],
      ),

    );
  }
}
