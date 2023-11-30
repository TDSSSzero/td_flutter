import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

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
    // print("home center x:$x , y:$y");
    state.center = Offset(x, y);
  }

  List<String> get menuString => ["获取ip"];
  void menuLogic(int index)async {
    switch (index) {
      case 0 :
        NetworkInterface.list().then((interfaces) {
          String _networkInterface = "";
          for (var interface in interfaces) {
            _networkInterface += "### name: ${interface.name}\n";
            int i = 0;
            for (var address in interface.addresses) {
              _networkInterface += "${i++}) ${address.address}\n";
            }
          }
          state.menuDesc.value = _networkInterface;
        });
        SmartDialog.dismiss();
    }
    print("cache path : ${(await getTemporaryDirectory()).path}");
  }

}
