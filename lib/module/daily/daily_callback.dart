import 'package:get/get.dart';
import 'package:td_flutter/common/pages.dart';
import 'package:td_flutter/pigeons/daily_pigeon_g.dart';

typedef PhotoCallback = void Function(String savePath);

typedef PlayMusicCallback = void Function();

class DailyCallbackImpl implements DailyCallback{

  // String savePath = "";
  late final PhotoCallback callback;
  late final PlayMusicCallback musicCallback;

  DailyCallbackImpl(this.callback);
  DailyCallbackImpl.music(this.musicCallback);

  @override
  void onChoicePhoto(String savePath) {
    // this.savePath = savePath;
    callback(savePath);
  }

  @override
  void onTouchNotification() {
    Get.toNamed(Pages.musicPlayerPage,arguments: 2);
    // musicCallback();
  }

}
