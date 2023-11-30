import 'package:get/get_navigation/get_navigation.dart';
import 'package:td_flutter/draw/draw/draw_view.dart';
import 'package:td_flutter/home/home_view.dart';
import 'package:td_flutter/module/anim/anim_view.dart';
import 'package:td_flutter/module/audio_waveforms/audio_waveforms_view.dart';
import 'package:td_flutter/module/auto_text/auto_text_view.dart';
import 'package:td_flutter/module/class_test/change_notify_test/change_notify_test_view.dart';
import 'package:td_flutter/module/constrain/constrain_view.dart';
import 'package:td_flutter/module/daily/daily_view.dart';
import 'package:td_flutter/module/hero_test/hero_test_view.dart';
import 'package:td_flutter/module/image_test/image_test_view.dart';
import 'package:td_flutter/module/long_press/long_press_view.dart';
import 'package:td_flutter/module/lottie/lottie_view.dart';
import 'package:td_flutter/module/flow_burst/mindset_view.dart';
import 'package:td_flutter/module/mindset_quill/mindset_quill_view.dart';
import 'package:td_flutter/module/music_player/music_player_view.dart';
import 'package:td_flutter/module/quill_test/quill_test_view.dart';
import 'package:td_flutter/module/spine/spine_view.dart';
import 'package:td_flutter/module/table_calendar/column_calendar/column_calendar_view.dart';
import 'package:td_flutter/module/table_calendar/hero_calendar/hero_calendar_view.dart';
import 'package:td_flutter/module/table_calendar/table_calendar_view.dart';
import 'package:td_flutter/module/test/test_view.dart';
import 'package:td_flutter/module/video_player/video_player_view.dart';

import '../module/chart/bar_chart.dart';
import '../module/chart/line_chart/line_chart_view.dart';
import '../module/hero_test/hero_detail_view.dart';
import '../module/lock_screen/lock_screen_view.dart';
import '../module/lock_screen_plus/lock_screen_plus_view.dart';
import '../module/mindset_plus/mindset_plus_view.dart';
import 'my_get_page.dart';

class Pages{
  static const String homePage = "/homePage";
  static const String lockScreenPage = "/lockScreenPage";
  static const String lockScreenPlusPage = "/LockScreenPlusPage";
  static const String linePage = "/linePage";
  static const String lottiePage = "/lottiePage";
  static const String animPage = "/animPage";
  static const String constrainPage = "/constrainPage";
  static const String testPage = "/testPage";
  static const String dailyPage = "/dailyPage";
  static const String musicPlayerPage = "/musicPlayerPage";
  static const String mindsetPage = "/mindsetPage";
  static const String mindsetPlusPage = "/mindsetPlusPage";
  static const String longPressPage = "/longPressPage";
  static const String videoPlayerPage = "/videoPlayerPage";
  static const String spinePage = "/spinePage";
  static const String quillPage = "/quillPage";
  static const String recordPage = "/recordPage";
  static const String autoTextPage = "/autoTextPage";
  static const String audioWaveformsPage = "/audioWaveformsPage";
  static const String barChartPage = "/barChartPage";
  static const String changeNotifierTestPage = "/changeNotifierTestPage";
  static const String mindsetQuillPage = "/mindsetQuillPage";
  static const String heroTestPage = "/heroTestPage";
  static const String heroDetailPage = "/heroDetailPage";
  static const String imageTestPage = "/imageTestPage";
  static const String tableCalendarPage = "/tableCalendarPage";
  static const String heroCalendarPage = "/heroCalendarPage";
  static const String tagCalendarPage = "/tagCalendarPage";

  static const String drawPage = "/drawPage";
  static const String particleBasePage = "/particleBasePage";
  static const String sendParticlePage = "/sendParticlePage";


  static List<GetPage> pageList = [
    GetPage(name: homePage, page: ()=>HomePage()),
    GetPage(name: animPage, page: () => AnimPage()),
    GetPage(name: linePage, page: () => LineChartPage()),
    GetPage(name: lockScreenPage, page: () => const LockScreenPage()),
    GetPage(name: lockScreenPlusPage, page: () => LockScreenPlusPage()),
    GetPage(name: lottiePage, page: () => LottiePage()),
    GetPage(name: constrainPage, page: () => ConstrainPage()),
    GetPage(name: dailyPage, page: () => DailyPage()),
    GetPage(name: musicPlayerPage, page: () => MusicPlayerPage()),
    GetPage(name: mindsetPage, page: () => MindsetPage()),
    GetPage(name: mindsetPlusPage, page: () => MindsetPlusPage()),
    GetPage(name: longPressPage, page: () => LongPressPage()),
    GetPage(name: videoPlayerPage, page: () => VideoPlayerPage()),
    GetPage(name: testPage, page: () => TestPage()),
    GetPage(name: spinePage, page: () => SpinePage()),
    GetPage(name: quillPage, page: () => QuillTestPage()),
    GetPage(name: autoTextPage, page: () => AutoTextPage()),
    GetPage(name: audioWaveformsPage, page: () => AudioWaveformsPage()),
    GetPage(name: barChartPage, page: () => BarChartSample3()),
    GetPage(name: changeNotifierTestPage, page: () => ChangeNotifyTestPage()),
    GetPage(name: mindsetQuillPage, page: () => MindsetQuillPage(),customTransition: MyCustomTransition()),
    GetPage(name: heroTestPage, page: () => HeroTestPage()),
    GetPage(name: heroDetailPage, page: () => HeroDetailView(),transition:Transition.rightToLeft,transitionDuration: Duration(milliseconds: 1000) ),
    GetPage(name: imageTestPage, page: () => ImageTestPage()),
    GetPage(name: tableCalendarPage, page: () => TableCalendarPage()),
    GetPage(name: heroCalendarPage, page: () => HeroCalendarPage()),
    GetPage(name: tagCalendarPage, page: () => ColumnCalendarPage()),
    GetPage(name: drawPage, page: () => DrawPage()),
  ];

  static Map<String,String> pageNames = {
    animPage :               'sheetDialog动画曲线',
    spinePage :              'spine动画',
    quillPage :              'quill富文本和自动缩小字体text对比',
    mindsetQuillPage :       'quill富文本',
    drawPage :               '绘制教程',
    heroTestPage :           'hero 动画',
    tableCalendarPage :      'hero 日历组件',
    imageTestPage :          'flutter手动截图',
    audioWaveformsPage :     '录音+波形图',
    autoTextPage :           '可输入的自动缩小文本Text',
    linePage :               '线形图',
    barChartPage :           '柱状图',
    lockScreenPage :         '指纹解锁',
    lockScreenPlusPage :     '指纹解锁+数字密码',
    constrainPage :          '官网-约束example',
    lottiePage :             'lottie动画',
    dailyPage :              '录音+打开相册',
    musicPlayerPage :        '音乐播放器',
    mindsetPage :            'flow组件测试',
    mindsetPlusPage :        'flow组件+手势检测',
    longPressPage :          '长按变色球',
    videoPlayerPage :        '视频播放器',
    testPage :               'test',
    changeNotifierTestPage : 'change notifier进度条'
  };

}