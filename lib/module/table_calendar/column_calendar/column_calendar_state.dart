import 'package:get/get.dart';

class ColumnCalendarState {
  final isShowMood = true.obs;
  //tableCalendar
  final lastDay = DateTime.now().obs;
  DateTime createTime = DateTime.now();
  final earliestTime = DateTime(1900);
  final selectDay = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;
  ColumnCalendarState() {
    ///Initialize variables
  }
}
