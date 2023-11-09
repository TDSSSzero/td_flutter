import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class DailyPigeonApi{
  bool requestRecordPermission();
  bool startRecord(String savePath);
  bool stopRecord();
  bool takePhoto(String photoPath);
}

@FlutterApi()
abstract class DailyCallback{
  void onChoicePhoto(String savePath);
  void onTouchNotification();
}