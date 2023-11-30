import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import 'hero_calendar_state.dart';

class HeroCalendarLogic extends GetxController {
  final HeroCalendarState state = HeroCalendarState();

  final QuillController quillController = QuillController.basic();
  final ScrollController quillScrollController = ScrollController();
  final ScrollController listViewScrollController = ScrollController();
  final PageController pageController = PageController();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<bool> onWillPop() async {
    return true;
  }

  void onTapDiaryButton() {
    state.isShowMood.value = false;
    state.calendarFormat.value = CalendarFormat.week;
  }

  void onTapMoodButton() {
    state.isShowMood.value = true;
    state.calendarFormat.value = CalendarFormat.month;
  }

  void onTapMoodChart() async {
  }

  ///切换日历页面时
  void onPageChanged(DateTime time) {
    if (time.year == DateTime.now().year &&
        time.month == DateTime.now().month) {
      state.selectDay.value = DateTime.now();
      state.focusedDay.value = DateTime.now();
    } else {
      state.selectDay.value = time;
      state.focusedDay.value = time;
    }
  }

  void onSelectedDay(DateTime selectedDay) {
    state.selectDay.value = selectedDay;
    state.focusedDay.value = selectedDay;
    // Log().i("onSelectedDay : ${TimeUtil.getStandardTime(selectedDay)}");
  }

  void goLast(double height) {
    //等待toolBar构建
    // 400(_buildCalendar) 56(appBar) 48(_buildDiaryButton) 28(状态栏)
    double move = 400 + 56 + 48 + height;

    Future.delayed(
        const Duration(milliseconds: 300),
        //移动到最下面
            () => listViewScrollController.animateTo(move,
            duration: const Duration(milliseconds: 100), curve: Curves.linear));
  }

}
