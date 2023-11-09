import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:td_flutter/pigeons/daily_pigeon_g.dart';

import 'daily_callback.dart';
import 'daily_state.dart';

class DailyLogic extends GetxController {
  final DailyState state = DailyState();
  final path = "".obs;
  late final DailyCallbackImpl callback;

  @override
  void onReady() {
    super.onReady();
    getRecordFiles();
    _initStreams();
    callback = DailyCallbackImpl((p){
      path.value = p;
    });
    DailyCallback.setup(callback);
  }

  @override
  void onClose() {
    super.onClose();
  }

  void requestRecordPermission()async{
    // if(await Permission.re){
    //
    // }
    bool isGet = await state.dailyPigeonApi.requestRecordPermission();
    print('isGetPermission $isGet');
    if(isGet){
      SmartDialog.showToast("已经获取权限");
    }
  }

  void startRecord()async{
    String filename = "${state.recordPath}${DateFormat("yyyyMMdd_HHmmss").format(DateTime.now())}record.m4a";
    bool isGet = await state.dailyPigeonApi.startRecord(filename);
    print('isStart $isGet');
    if(isGet){
      SmartDialog.show(
          backDismiss: false,
          clickMaskDismiss: false,
          // onDismiss: stopRecord,
          builder: (context){
            return Container(
              width: 200,
              height: 200,
              color: Colors.white,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(child:  Text('正在录音...')),
                  const Expanded(flex:2,child:  Icon(Icons.record_voice_over)),
                  Expanded(child: ElevatedButton(onPressed: (){
                    stopRecord();
                    SmartDialog.dismiss(status: SmartStatus.dialog);
                  }, child: const Text('停止录音'))),
                ],
              ),
            );
          });
    }


  }

  void stopRecord() async{
    await state.dailyPigeonApi.stopRecord();
    getRecordFiles();
    // Share.shareXFiles([XFile(state.fileList[0])]);
  }

  Future<List<String>> getFilesInFolder(String folderPath) async {
    Directory directory = Directory(folderPath);
    if (!await directory.exists()) {
      directory.create(recursive: true);
      // 文件夹不存在
      return [];
    }
    List<String> fileNames = [];
    List<FileSystemEntity> entities = directory.listSync(recursive: false);
    for (FileSystemEntity entity in entities) {
      if (entity is File) {
        fileNames.add(entity.path.split('/').last); // 获取文件名
      }
    }
    return fileNames;
  }

  void getRecordFiles()async{
    Directory dir = await getApplicationDocumentsDirectory();
    state.recordPath = "${dir.path}/audio_record/";
    state.fileList.value = await getFilesInFolder(state.recordPath);
    Logger().i("file list : ${state.fileList.value}");
  }

  void _initStreams() {
    state.durationSubscription = state.player.onDurationChanged.listen(
            (duration) => state.duration.value = duration
    );

    state.positionSubscription = state.player.onPositionChanged.listen(
            (p) => state.position.value = p
    );

    state.playerCompleteSubscription = state.player.onPlayerComplete.listen((event) {
      state.playerState = PlayerState.stopped;
      state.position.value = Duration.zero;
    });

    state.playerStateChangeSubscription =
        state.player.onPlayerStateChanged.listen((s) {
          state.playerState = s;
        });
  }

  String getFilePathByIndex(int index){
    return "${state.recordPath}${state.fileList[index]}";
  }

  void onLongPressDeleteFile(int index){
    String path = getFilePathByIndex(index);
    SmartDialog.show(builder: (ctx){
      return Container(
        color: Colors.white,
        width: 200,
        height: 200,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('确定删除此 ${state.fileList[index]} 录音吗？'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text('取消',style: TextStyle(color: Colors.blue,fontSize: 20),),
                  onPressed: ()=>SmartDialog.dismiss(status: SmartStatus.dialog),
                ),
                TextButton(
                  child: const Text('确定',style: TextStyle(color: Colors.red,fontSize: 20),),
                  onPressed: (){
                    File file = File(path);
                    file.deleteSync();
                    getRecordFiles();
                    SmartDialog.dismiss(status: SmartStatus.dialog);
                  },
                ),
              ],
            )
          ],
        ),
      );
    });
  }



}
