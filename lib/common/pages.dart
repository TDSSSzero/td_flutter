import 'package:get/get_navigation/get_navigation.dart';
import 'package:td_flutter/home/home_view.dart';
import 'package:td_flutter/module/anim/anim_view.dart';
import 'package:td_flutter/module/audio_waveforms/audio_waveforms_view.dart';
import 'package:td_flutter/module/auto_text/auto_text_view.dart';
import 'package:td_flutter/module/chart/chart_view.dart';
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
import 'package:td_flutter/module/test/test_view.dart';
import 'package:td_flutter/module/video_player/video_player_view.dart';

import '../module/auido_wave/audio_wave.dart';
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
  static const String chartPage = "/chartPage";
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
  // static const String markdownPage = "/markdownPage";
  static const String recordPage = "/recordPage";
  static const String wavePage = "/wavePage";
  static const String autoTextPage = "/autoTextPage";
  static const String audioWaveformsPage = "/audioWaveformsPage";
  static const String barChartPage = "/barChartPage";
  static const String changeNotifierTestPage = "/changeNotifierTestPage";
  static const String mindsetQuillPage = "/mindsetQuillPage";
  static const String heroTestPage = "/heroTestPage";
  static const String heroDetailPage = "/heroDetailPage";
  static const String imageTestPage = "/imageTestPage";


  static List<GetPage> pageList = [
    GetPage(name: homePage, page: ()=>HomePage()),
    GetPage(name: animPage, page: () => AnimPage()),
    GetPage(name: linePage, page: () => LineChartPage()),
    GetPage(name: chartPage, page: () => ChartPage()),
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
    // GetPage(name: recordPage, page: () => RecordPage(onStop: (String path) {  },)),
    GetPage(name: wavePage, page: () => AudioWavePage()),
    GetPage(name: autoTextPage, page: () => AutoTextPage()),
    GetPage(name: audioWaveformsPage, page: () => AudioWaveformsPage()),
    GetPage(name: barChartPage, page: () => BarChartSample3()),
    GetPage(name: changeNotifierTestPage, page: () => ChangeNotifyTestPage()),
    GetPage(name: mindsetQuillPage, page: () => MindsetQuillPage(),customTransition: MyCustomTransition()),
    GetPage(name: heroTestPage, page: () => HeroTestPage()),
    GetPage(name: heroDetailPage, page: () => HeroDetailView(),transition:Transition.rightToLeft,transitionDuration: Duration(milliseconds: 1000) ),
    GetPage(name: imageTestPage, page: () => ImageTestPage()),
  ];

  static List<String> pageNames = [
    animPage,
    spinePage,
    quillPage,
    mindsetQuillPage,
    heroTestPage,
    imageTestPage,
    audioWaveformsPage,
    wavePage,
    autoTextPage,
    linePage,
    barChartPage,
    chartPage,
    lockScreenPage,
    lockScreenPlusPage,
    constrainPage,
    lottiePage,
    dailyPage,
    musicPlayerPage,
    mindsetPage,
    mindsetPlusPage,
    longPressPage,
    videoPlayerPage,
    testPage,
    changeNotifierTestPage,
  ];

}