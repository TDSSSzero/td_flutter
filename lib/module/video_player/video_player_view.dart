import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td_flutter/common/file_path.dart';
import 'package:video_player/video_player.dart';

import 'video_player_logic.dart';

class VideoPlayerPage extends StatelessWidget {
  VideoPlayerPage({Key? key}) : super(key: key);

  final logic = Get.put(VideoPlayerLogic());
  final state = Get.find<VideoPlayerLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          alignment: Alignment.center,
            children:[
              _buildBG(),
              const Text("video player",style: TextStyle(color: Colors.white),),
              Positioned(top: 450,child: _buildButtons(),),
            ]
        ));
  }

  Widget _buildBG(){
    return Obx(() => state.isVideo.value
        ? VideoPlayer(logic.controller.value)
        : const Image(
      image: AssetImage(FilePath.themeBg1),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.fill,
    ));
  }

  Widget _buildButtons(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: ()=>logic.onChangeVideo(0), child: const Text("change galaxy")),
        ElevatedButton(onPressed: ()=>logic.onChangeVideo(1), child: const Text("change sparkler")),
        ElevatedButton(onPressed: ()=>state.isVideo.toggle(), child: const Text("change video")),
        ElevatedButton(onPressed: ()=>print(logic.controller.runtimeType), child: const Text("test video")),
      ],
    );
  }

}
