import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class HeroCalendarState {
  final isShowMood = true.obs;
  //tableCalendar
  final lastDay = DateTime.now().obs;
  DateTime createTime = DateTime.now();
  final earliestTime = DateTime(1900);
  final selectDay = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;
  final calendarFormat = CalendarFormat.month.obs;
  HeroCalendarState() {
    ///Initialize variables
  }
}
