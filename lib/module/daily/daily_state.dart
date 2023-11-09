import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../pigeons/daily_pigeon_g.dart';

class DailyState {

  final selectDay = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;

  final calendarLocale = 'zh-CN'.obs;

  final DailyPigeonApi dailyPigeonApi = DailyPigeonApi();

  String recordPath = "";

  final fileList = [].obs;

  //play audio

  PlayerState? playerState;
  StreamSubscription? durationSubscription;
  StreamSubscription? positionSubscription;
  StreamSubscription? playerCompleteSubscription;
  StreamSubscription? playerStateChangeSubscription;

  final playFilename = ''.obs;
  final duration = Duration().obs;
  final position = Duration().obs;
  final player = AudioPlayer();

  DailyState() {
    ///Initialize variables
  }
}
