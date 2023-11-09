import 'package:get/get.dart';
import 'package:mmkv/mmkv.dart';
import 'package:path_provider/path_provider.dart';

import 'common/file_path.dart';

Future<void> initServices() async{
  print("start init");
  final dir =  await getTemporaryDirectory();
  FilePath.audioTempPath = "${dir.path}/temp.m4a";
  await Get.putAsync(() => MMKVService().init());
  print("end init");
}

class MMKVService extends GetxService{

  late final MMKV mmkv;
  Future<MMKVService> init() async{
    final initDir = await MMKV.initialize();
    print("initDir: $initDir");
    final support = await getApplicationSupportDirectory();
    final rootDir = "${support.path}/flutter_mmkv/mindset_mmkv";
    print("rootDir: $rootDir");
    mmkv = MMKV("mindset_mmkv",mode: MMKVMode.MULTI_PROCESS_MODE,rootDir: rootDir);
    mmkv.encodeInt("init", 1);
    return this;
  }
}