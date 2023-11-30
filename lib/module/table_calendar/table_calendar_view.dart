import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td_flutter/common/pages.dart';

import 'table_calendar_logic.dart';

class TableCalendarPage extends StatelessWidget {
  TableCalendarPage({Key? key}) : super(key: key);

  final logic = Get.put(TableCalendarLogic());
  final state = Get.find<TableCalendarLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              Get.toNamed(Pages.heroCalendarPage);
            }, child: Text("展开动画")),
            ElevatedButton(onPressed: (){
              Get.toNamed(Pages.tagCalendarPage);
              }, child: Text("跳转标签")),
          ],
        ),
      ),
    );
  }
}
