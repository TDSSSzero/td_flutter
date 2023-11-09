
import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:td_flutter/common/file_path.dart';

import 'audio_waveforms_state.dart';

class AudioWaveformsLogic extends GetxController with WidgetsBindingObserver {
  final AudioWaveformsState state = AudioWaveformsState();

  late final path = "".obs;
  late final RecorderController recorderController;
  final isRecording = false.obs;
  final isRecordingCompleted = false.obs;
  bool isLoading = true;

  Timer? timer;
  String savePath = "";

  @override
  void onReady() {
    WidgetsBinding.instance.addObserver(this);
    super.onReady();
    _init();
    getRecordFiles();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    if(timer != null && timer!.isActive){
      timer!.cancel();
    }
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.detached:
        print("flutter app lifecycle detached");
        break;
      case AppLifecycleState.inactive:
        print("flutter app lifecycle inactive");
        break;
      case AppLifecycleState.resumed:
        print("flutter app lifecycle resumed");
        break;
      case AppLifecycleState.paused:
        print("flutter app lifecycle paused");
        break;
    }
  }

  _init()async{
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100
    ..bitRate = 192000
    ;
    final dir =  await getTemporaryDirectory();
    path.value = "${dir.path}/temp.m4a";
    final appDir = await getApplicationSupportDirectory();
    int id = DateTime.now().millisecondsSinceEpoch;
    savePath = "${appDir.path}/${id}_audio";
  }
  void startOrStopRecording() async {
    try {
      if (isRecording.value) {
        recorderController.reset();

        final path = await recorderController.stop(false);

        if (path != null) {
          isRecordingCompleted.value = true;
          debugPrint(path);
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
        }
        if(timer != null && timer!.isActive){
          timer!.cancel();
        }
        getRecordFiles();
      } else {
        await recorderController.record(path: path.value);
        //开始计时
        //设置计时器
        timer = Timer.periodic(const Duration(seconds: 1), (timer) async{
          int value = timer.tick;
          print("timer tick : $value");
          if(value == 60*60){
            startOrStopRecording();
            timer.cancel();
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isRecording.toggle();
    }
  }

  void _refreshWave() {
    if (isRecording.value) recorderController.refresh();
  }
  void getRecordFiles()async{
    final appDir = await getApplicationSupportDirectory();
    state.fileList.value = await FilePath.getFilesInFolder("${appDir.path}/");
    Logger().i("file list : ${state.fileList.value}");
  }
}
