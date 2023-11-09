import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:td_flutter/common/pages.dart';

import 'daily_logic.dart';

class DailyPage extends StatelessWidget {
  DailyPage({Key? key}) : super(key: key);

  final logic = Get.put(DailyLogic());
  final state = Get.find<DailyLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            // padding: EdgeInsets.only(top: Get.statusBarHeight),
            alignment: Alignment.center,
            child: Obx(() {
              return TableCalendar(
                firstDay: DateTime.utc(DateTime.now().year - 1),
                lastDay: DateTime.now(),
                focusedDay: state.focusedDay.value,
                selectedDayPredicate: (day) {
                  return isSameDay(state.selectDay.value, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  state.selectDay.value = selectedDay;
                  state.focusedDay.value = selectedDay;
                },
                calendarFormat: CalendarFormat.month,
                locale: state.calendarLocale.value,
                headerStyle: const HeaderStyle(formatButtonVisible: false),
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    if (day.weekday == DateTime.sunday) {
                      final text =
                          DateFormat.E(state.calendarLocale.value).format(day);
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  },
                  headerTitleBuilder: (context, day) {
                    final text =
                        DateFormat('yyyy年MM月dd日', state.calendarLocale.value)
                            .format(day);
                    return Text(
                      text,
                    );
                  },
                ),
              );
            }),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('点击',style: TextStyle(color: Colors.greenAccent),),
              Text('文件名播放录音'),
            ],
          )),
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('长按',style: TextStyle(color: Colors.red),),
              Text('文件名播放录音'),
            ],
          )),
          ElevatedButton(
              onPressed: () => logic.requestRecordPermission(),
              child: const Text('请求录音权限')),
          ElevatedButton(
              onPressed: () => logic.startRecord(), child: const Text('开始录音')),
          Expanded(
            flex: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Obx(() {
            return ListView.builder(
                  itemCount: state.fileList.length,
                  itemBuilder: (_, index) =>
                      Card(
                        child: InkWell(
                            onTap: ()=>Get.toNamed(Pages.musicPlayerPage,arguments:"${state.recordPath}${state.fileList[index]}"),
                            onLongPress: ()=>logic.onLongPressDeleteFile(index),
                            child: Container(height:40,alignment: Alignment.center,child: Text(state.fileList[index]))),
                      ));
          }),
              )),
          Obx(() =>
          logic.path.value != ""
              ?
          Expanded(child: Image(image: FileImage(File(logic.path.value))))
              : SizedBox()
          ),
          ElevatedButton(
              onPressed: () async{
                final temp = await getTemporaryDirectory();
                String path = "${temp.path}/temp";
                print("path : ${path}");
                state.dailyPigeonApi.takePhoto(path);
              }, child: Text('take photo')),
        ],
      ),
    ));
  }
}
