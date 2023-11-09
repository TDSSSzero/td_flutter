import 'dart:async';

import 'package:flutter/material.dart';
import 'package:td_flutter/module/class_test/change_notify_test/detail_progress_view.dart';
import 'package:td_flutter/module/class_test/change_notify_test/my_notifier.dart';

class ChangeNotifyTestPage extends StatefulWidget {
  ChangeNotifyTestPage({Key? key}) : super(key: key);

  @override
  State<ChangeNotifyTestPage> createState() => _ChangeNotifyTestPageState();
}

class _ChangeNotifyTestPageState extends State<ChangeNotifyTestPage> {

  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DetailProgressView(),
            ElevatedButton(onPressed: (){
              _startTimer();
            }, child: Text("start")),
          ],
        ),
      ),
    );
  }

  void _startTimer(){
    if(_timer != null) return;
    if(myNotifier.value == 1.0){
      myNotifier.value = 0;
    }
    _timer = Timer.periodic(const Duration(milliseconds: 200), _updateProgress);
  }

  void _updateProgress(Timer timer){
    if(myNotifier.value >= 1.0){
      _timer?.cancel();
      _timer = null;
      return;
    }
    myNotifier.value += 0.01;
  }

}
