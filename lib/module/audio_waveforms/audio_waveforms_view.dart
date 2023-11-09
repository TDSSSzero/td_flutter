import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:td_flutter/common/encrypt_utils.dart';

import '../../common/file_path.dart';
import 'audio_waveforms_logic.dart';
import 'chat_bubble.dart';

class AudioWaveformsPage extends StatelessWidget {
  AudioWaveformsPage({Key? key}) : super(key: key);

  final logic = Get.put(AudioWaveformsLogic());

  final state = Get.find<AudioWaveformsLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Center(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
              ),
              if (logic.isRecordingCompleted.value && !logic.isRecording.value)
                WaveBubble(
                  path: logic.path.value,
                ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: logic.isRecording.value
                    ? AudioWaveforms(
                        enableGesture: true,
                        size: Size(MediaQuery.of(context).size.width / 2, 50),
                        recorderController: logic.recorderController,
                        waveStyle: const WaveStyle(
                          waveColor: Colors.white,
                          extendWaveform: true,
                          showMiddleLine: false,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: const Color(0xFF1E1B26),
                        ),
                        padding: const EdgeInsets.only(left: 18),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1B26),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.only(left: 18),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: const TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Start Record!!",
                            hintStyle: TextStyle(color: Colors.white54),
                            contentPadding: EdgeInsets.only(top: 16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
              ),
              Container(
                height: 100,
                padding: EdgeInsets.all(20),
                child: IconButton(
                  onPressed: logic.startOrStopRecording,
                  icon: Icon(logic.isRecording.value ? Icons.stop : Icons.mic),
                  color: Colors.grey,
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 2),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
                  iconSize: 60,
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    String path = EncryptUtils.encryptAudio(logic.savePath);
                    print("encrypt savePath: ${logic.savePath}");
                    print("encrypt audio success: $path");
                    Share.shareXFiles([XFile(path)]);
                  },
                  child: const Text("encrypt")),
              ElevatedButton(
                  onPressed: () async {
                    print("decryptAudio savePath: ${logic.savePath}");
                    EncryptUtils.decryptAudio(logic.savePath);
                    Share.shareXFiles([XFile(FilePath.audioTempPath)]);
                  },
                  child: const Text("decrypt")),
              ElevatedButton(
                  onPressed: () async {
                    final temp = await getTemporaryDirectory();
                    String path = "${temp.path}/temp.m4a";
                    Share.shareXFiles([XFile(path)]);
                  },
                  child: Text("share")),
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: state.fileList.length,
                        itemBuilder: (_, index) => Card(
                              child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: Text(state.fileList[index]))),
                            ));
                  }),
                ),
              )
            ],
          );
        }),
      ),
    ));
  }
}
