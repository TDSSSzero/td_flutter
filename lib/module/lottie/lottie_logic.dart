import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'lottie_state.dart';

class LottieLogic extends GetxController with GetSingleTickerProviderStateMixin{
  final LottieState state = LottieState();
  String introOpen1In = "assets/open1/x1in.json";
  String introOpen1Idle = "assets/open1/x1idle.json";
  late final AnimationController controller;
  Duration? duration;
  final lottiePath = "assets/open1/x1in.json".obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    controller = AnimationController(
        vsync: this, duration: duration ?? const Duration(seconds: 1));
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    controller.stop();
    controller.dispose();
    super.onClose();
  }

  void onAnimLoaded(LottieComposition composition) {
    controller.duration = composition.duration;
    print('duration ${composition.duration.inMilliseconds}');
    controller.forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // print('completed');
        // state.textOpacity.value = 1;
        lottiePath.value = introOpen1Idle;
        controller.repeat();
      }
    });
  }
}
