import 'package:get/get.dart';
import 'package:td_flutter/common/file_path.dart';
import 'package:video_player/video_player.dart';

import 'video_player_state.dart';

class VideoPlayerLogic extends GetxController {
  final VideoPlayerState state = VideoPlayerState();

  final VideoPlayerOptions options = VideoPlayerOptions(mixWithOthers: true);
  late final controller = VideoPlayerController.asset(FilePath.galaxyVideo,videoPlayerOptions: options).obs;

  @override
  void onReady() {
    super.onReady();
    controller.value = VideoPlayerController.asset(FilePath.galaxyVideo,videoPlayerOptions: options)
    ..initialize().then((value){
      controller.value.setLooping(true);
      controller.value.play();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void onChangeVideo(int index){
    switch(index){
      case 0:
        controller.value = VideoPlayerController.asset(FilePath.galaxyVideo,videoPlayerOptions: options)
          ..initialize().then((value){
            controller.value.setLooping(true);
            controller.value.play();
          });
        break;
      case 1:
        controller.value = VideoPlayerController.asset(FilePath.sparklerVideo,videoPlayerOptions: options)
          ..initialize().then((value){
            controller.value.setLooping(true);
            controller.value.play();
          });
        break;
    }
    controller.refresh();
  }

}
