import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'anim_logic.dart';

class AnimPage extends StatefulWidget {
  AnimPage({Key? key}) : super(key: key);

  @override
  State<AnimPage> createState() => _AnimPageState();
}

class _AnimPageState extends State<AnimPage> with TickerProviderStateMixin {
  final logic = Get.put(AnimLogic());

  final state = Get
      .find<AnimLogic>()
      .state;

  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 500),
      vsync: this,
    );
    // controller.drive(CurveTween(curve: Curves.easeInOutQuint));
    controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        controller.stop();
        controller.animateTo(0.7,
            duration: Duration(milliseconds: 500), curve: Curves.easeOutBack);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(onPressed: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    transitionAnimationController: controller,
                    enableDrag: false,
                    builder: (_) {
                      return
                        SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Center(
                                child: ClipRRect(
                                  // 裁剪为圆角
                                    borderRadius:
                                    const BorderRadius.vertical(
                                        top: Radius.circular(30)),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 3.0,
                                        sigmaY: 3.0,
                                      ),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.4),
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end,
                                              children: [
                                                Text("test")
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        );
                    });
              }, child: Text("show")),
            ],
          ),
        ),
      ),
    );
  }
}
