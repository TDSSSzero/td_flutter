import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import 'anim_state.dart';

class AnimLogic extends GetxController with GetSingleTickerProviderStateMixin {
  final AnimState state = AnimState();

  // late final AnimationController controller;

  @override
  void onReady() {
    // controller = AnimationController(
    //   duration: Duration(milliseconds: 300),
    //   reverseDuration: Duration(milliseconds: 500),
    //   vsync: this,
    // );
    // controller.drive(CurveTween(curve: Curves.easeOutBack));
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

}
