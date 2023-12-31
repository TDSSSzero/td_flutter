import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spine_flutter/spine_flutter.dart';
import 'package:td_flutter/common/pages.dart';

import 'init.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //设置屏幕方向为竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //immersiveSticky全屏模式，始终显示顶部状态栏overlays:top
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,overlays: [SystemUiOverlay.top]);
  await initSpineFlutter(enableMemoryDebugging: false);
  await initServices();
  initializeDateFormatting().then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  // This widget is the root of your application.

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    getFile();
  }
  
  getFile()async{
    final dir = await getApplicationSupportDirectory();
    String path = "${dir.path}/flutter_mmkv/bettermindset_mmkv";
    print(path);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.detached:
        print("lifecycle detached");
        break;
      case AppLifecycleState.inactive:
        print("lifecycle inactive");
        break;
      case AppLifecycleState.resumed:
        print("lifecycle resumed");
        break;
      case AppLifecycleState.paused:
        print("lifecycle paused");
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double keyHeight = 0.0;
    if(MediaQuery.of(context).viewInsets.bottom!=0.0){
      //键盘高度是会变的，键盘隐藏的时候会返回0，所以为0是不赋值
      keyHeight = MediaQuery.of(context).viewInsets.bottom;
    }
    // print("keyHeight: $keyHeight");
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      initialRoute: Pages.homePage,
      getPages: Pages.pageList,
      builder: FlutterSmartDialog.init(builder: _builder),
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    //全局字体缩放为1
    return MediaQuery(
      data: MediaQueryData.fromView(View.of(context)).copyWith(textScaleFactor: 1),
      child: Scaffold(
        body: child,
      ),
    );
  }
}
