import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../module/daily/daily_callback.dart';
import '../pigeons/daily_pigeon_g.dart';
import 'home_state.dart';

class HomeLogic extends GetxController {
  final HomeState state = HomeState();


  late final DailyCallbackImpl callback;
  @override
  void onReady() {
    callback = DailyCallbackImpl.music((){
      print("callback music !!!!!!!!!!!!!!!!!!!");
    });
    DailyCallback.setup(callback);
    DateTime.now();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void getCenterOffset(BuildContext context){
    final x = MediaQuery.of(context).size.width / 2;
    final y = MediaQuery.of(context).size.height / 2;
    print("home center x:$x , y:$y");
    state.center = Offset(x, y);
  }

}
