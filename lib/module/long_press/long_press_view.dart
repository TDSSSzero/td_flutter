import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'long_press_logic.dart';

class LongPressPage extends StatefulWidget {
  LongPressPage({Key? key}) : super(key: key);

  @override
  State<LongPressPage> createState() => _LongPressPageState();
}

class _LongPressPageState extends State<LongPressPage> {
  final logic = Get.put(LongPressLogic());

  final state = Get.find<LongPressLogic>().state;

  static const Duration halfSecond = Duration(milliseconds: 500);

  double scale = 0;
  int index = 0;

  List<Color> colors = [
    Colors.blue,
    Colors.greenAccent,
    Colors.yellow,
    Colors.cyan,
    Colors.purple,
    Colors.red,
    Colors.red
  ];

  double _radius = 50.0;
  static const maxRadius = 110.0;
  Color _color = Colors.blue;
  bool _isPressing = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(),
          Expanded(
              child: Text(DateFormat('yyyy年MM月dd日').format(DateTime.now()))),
        // Expanded(
        //     child: ElevatedButton(onPressed: ()=>HapticFeedback.heavyImpact(), child: const Text('vibrate'))),
          const Spacer(),
          Expanded(
              flex: 3,
              child: GestureDetector(
                onLongPressStart: _onLongPressStart,
                onLongPressEnd: _onLongPressEnd,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _radius * 2,
                  height: _radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _color,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _onLongPressStart(LongPressStartDetails details) {
    print('long press start');
    setState(() {
      _isPressing = true;
    });
    _startAnimation();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _isPressing = false;
    });
  }

  void _startAnimation() async {
    while (_isPressing) {
      await Future.delayed(const Duration(seconds: 1));
      if (_isPressing) {
        if(_radius < maxRadius){
          setState(() {
            // Update radius and color based on your requirements
            index++;
            _radius += 10.0;
            _color = colors[index];
            print(index);
            print(_radius);
            HapticFeedback.selectionClick();
          });
        }
      }
    }
  }
}
