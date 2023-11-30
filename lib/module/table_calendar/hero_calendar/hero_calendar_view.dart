import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../widgets/debug_dialog.dart';
import '../../mindset_quill/quill/mindset_quill_editor.dart';
import '../../mindset_quill/quill/mindset_quill_toolbar.dart';
import 'hero_calendar_logic.dart';

class HeroCalendarPage extends StatefulWidget {
  HeroCalendarPage({Key? key}) : super(key: key);

  @override
  State<HeroCalendarPage> createState() => _HeroCalendarPageState();
}

class _HeroCalendarPageState extends State<HeroCalendarPage> {
  final logic = Get.put(HeroCalendarLogic());

  final state = Get.find<HeroCalendarLogic>().state;

  final List<String> moodNames = [
    "Happy", "Excited", "Relax", "Calm",
    "Sad", "Angry", "Sick", "Bored", "Tangled", "Worried"];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: WillPopScope(
            onWillPop: logic.onWillPop,
            child: SafeArea(
                child:
                Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      _buildListViewBody(),
                      _buildToolbar(),
                    ])
            )));
  }

  Widget _buildListViewBody() {
    return SizedBox(
      width: 500,
      height: 1000,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        controller: logic.listViewScrollController,
        children: [
          // _buildHeader(),
          _buildDiaryButton(),
          // _buildCalendar(),
          _buildAnimatedCalendar(),
          const SizedBox(height: 20),
          _buildMoodOrDiary(),
        ],
      ),
    );
  }

  Widget _buildDiaryButton() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(child: Obx(() {
            return state.isShowMood.value
                ? ElevatedButton(
                onPressed: logic.onTapDiaryButton, child: Text("writeDaily"))
                : ElevatedButton(
                onPressed: logic.onTapMoodButton, child: Text("saveMood"));
          })),
          Expanded(
              child: ElevatedButton(
                  onPressed: logic.onTapMoodChart, child: Text("moodChart")))
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return SizedBox(
      height: 400,
      child: Obx(() {
        return TableCalendar(
          //style
          headerStyle: const HeaderStyle(formatButtonVisible: false),
          //logic
          onHeaderTapped: _showChooseCalendarDialog,
          locale: "zh",
          firstDay: state.earliestTime,
          lastDay: state.lastDay.value,
          focusedDay: state.focusedDay.value,
          onDaySelected: (selectedDay, focusedDay) => logic.onSelectedDay(selectedDay),
          selectedDayPredicate: (day) {
            return isSameDay(state.selectDay.value, day);
          },
          onPageChanged: logic.onPageChanged,
          calendarFormat: CalendarFormat.month,
        );
      }),
    );
  }

  Widget _buildAnimatedCalendar() {
    return Obx(() {
      return AnimatedCrossFade(
          firstChild: _buildMoodCalendar(),
          secondChild: _buildDiaryCalendar(),
          crossFadeState: state.isShowMood.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
          firstCurve: Curves.easeInCirc,
          secondCurve: Curves.easeInToLinear,
      );
    });
  }

  Widget _buildMoodCalendar() {
    return Obx(() {
      return TableCalendar(
        headerStyle: const HeaderStyle(formatButtonVisible: false),
        onHeaderTapped: _showChooseCalendarDialog,
        locale: "zh",
        firstDay: state.earliestTime,
        lastDay: state.lastDay.value,
        focusedDay: state.focusedDay.value,
        onDaySelected: (selectedDay, focusedDay) =>
            logic.onSelectedDay(selectedDay),
        selectedDayPredicate: (day) {
          return isSameDay(state.selectDay.value, day);
        },
        onPageChanged: logic.onPageChanged,
        calendarFormat: CalendarFormat.month,
      );
    });
  }

  Widget _buildDiaryCalendar() {
    return Obx(() {
      return TableCalendar(
        headerStyle: const HeaderStyle(formatButtonVisible: false),
        onHeaderTapped: _showChooseCalendarDialog,
        locale: "zh",
        firstDay: state.earliestTime,
        lastDay: state.lastDay.value,
        focusedDay: state.focusedDay.value,
        onDaySelected: (selectedDay, focusedDay) =>
            logic.onSelectedDay(selectedDay),
        selectedDayPredicate: (day) {
          return isSameDay(state.selectDay.value, day);
        },
        onPageChanged: logic.onPageChanged,
        calendarFormat: CalendarFormat.week,
      );
    });
  }

  Widget _buildMoodOrDiary() {
    return Obx(() {
      return state.isShowMood.value ? _buildMood() : _buildDiary();
    });
  }

  Widget _buildMood() {
    return Container(
      height: 300,
      child: Wrap(
          children: _buildMoodChildren()
      ),
    );
  }

  List<Widget> _buildMoodChildren() {
    List<Widget> list = [];
    for (int i = 0; i < 10; i++) {
      list.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: moodNames[i],
            groupValue: null,
            onChanged: (m){

            },
          ),
          Text(moodNames[i]),
          const SizedBox(
            width: 40,
          )
        ],
      ));
    }
    return list;
  }

  Widget _buildDiary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Container(
            color: Colors.black12,
            height: 150,
            child: _buildDiaryQuillEditor(),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryQuillEditor() {
    return MindsetQuillEditor(
      quillController: logic.quillController,
      scrollController: logic.quillScrollController,
      maxTextLength: 121,
      onTextChanged: (doc){},
      focusNode: FocusNode(),
      autoFocus: false,
      document: logic.quillController.document,
      defaultFontSize: 20,
      onTextFontChanged: (size){},
    );
  }

  Widget _buildToolbar() {
    return KeyboardVisibilityBuilder(builder: (_, isShow) {
      double topPadding = MediaQuery.of(context).padding.top;

      isShow ? logic.goLast(topPadding) : null;
      print('topPadding $topPadding');
      return Container(
          color: isShow ? Colors.white : Colors.transparent,
          height: 40,
          width: double.infinity,
          child: isShow
              ? MindsetQuillBar(
            controller: logic.quillController,
          )
              : const SizedBox());
    });
  }

  Future<void> _showChooseCalendarDialog(DateTime selectedTime) async {
    DateTime? date;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) =>
          Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            // Use a SafeArea widget to avoid system overlaps.
            child: SafeArea(
                top: false,
                child:
                CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    minimumYear: 1990,
                    maximumDate: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    showDayOfWeek: true,
                    onDateTimeChanged: (time) {
                      date = time;
                      print(time);
                    }
                )

            ),
          ),
    );
    if (date != null) {
      logic.onSelectedDay(date!);
    }
  }
}
