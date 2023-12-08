import 'package:flutter/material.dart';
import 'package:td_flutter/module/mood_handle/widget/mood_painter.dart';

class MoodCustom extends StatefulWidget {
  final double width;
  final double height;
  final bool isPlay;
  const MoodCustom({super.key,required this.width,required this.height,required this.isPlay});

  @override
  State<MoodCustom> createState() => _MoodCustomState();
}

class _MoodCustomState extends State<MoodCustom> with SingleTickerProviderStateMixin {
  final childSize = 50.0;

  double row1    = 0.0;
  double row2    = 0.0;
  double column1 = 0.0;
  double column2 = 0.0;

  late final AnimationController _controller;
  double _value = 0.0;
  bool isOpen = false;
  Offset initOffset = Offset.zero;
  Offset endOffset = Offset.zero;

  final colors = [
    Colors.red,Colors.yellow,Colors.blue,Colors.green,
    Colors.lightBlueAccent,Colors.greenAccent,
    Colors.amber,Colors.brown,Colors.deepPurpleAccent,Colors.cyanAccent,
  ];

  List<Offset> leftTopOffsets = [];

  @override
  void initState() {
    super.initState();
    //小正方形之间计算间隔
    row1    = _getSpacing(widget.width, childSize, 4);
    row2    = _getSpacing(widget.height,childSize,2);
    column1 = _getSpacing(widget.height, childSize, 3);
    column2 = _getSpacing(widget.height, childSize, 2);
    print("row1 : $row1, row2: $row2, column1: $column1, column2 : $column2");
    //(0,0)
    initOffset = Offset(widget.width / 2 - childSize / 2, widget.height / 2 - childSize / 2);
    endOffset = Offset(widget.width / 2 - childSize / 2, widget.height / 2 - childSize / 2);
    // print("initOffset : $initOffset");

    for (int i = 0; i < 10; i++) {
      if(i < 4){
        //每个小正方形的位移量
        double translateX = i * (childSize + row1);
        leftTopOffsets.add(Offset(translateX - initOffset.dx, -initOffset.dy));
      }else if(i < 6){
        final x = i - 4;
        double translateX = x * (childSize + row2);
        double translateY = childSize + column1;
        leftTopOffsets.add(Offset(translateX - initOffset.dx, translateY -initOffset.dy));
      }else{
        final n = i - 6;
        double translateX = n * (childSize + row1);
        double translateY = childSize + column2;
        leftTopOffsets.add(Offset(translateX - initOffset.dx, translateY -initOffset.dy));
      }
    }
    print("leftop : $leftTopOffsets");

    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300)
    );
    _controller.addListener(() {
      _value = _controller.value;
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        if(!isOpen){
          _controller.forward();
          isOpen = true;
        }
        initOffset = details.localPosition;
        print("initOffset localPosition : $initOffset");
        setState(() {

        });
      },
      onPanEnd: (details) {
        print("up localPosition : $endOffset");
        // final judgeOffset = Offset(endOffset.dx - 125 / 2, endOffset.dy - 125 / 2);
        // print("judge offset : $judgeOffset");
        if(isOpen){
          _controller.reverse();
          isOpen = false;
        }
        initOffset = Offset.zero;
        endOffset = Offset.zero;
        setState(() {

        });
      },
      onPanUpdate: (details){

        endOffset = details.localPosition;
        setState(() {

        });
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Colors.amber.withOpacity(0.2),
        child: CustomPaint(
          painter: MoodPainter(initOffset, endOffset, leftTopOffsets),
        ),
      ),
    );
  }

  double _getSpacing(double parentSize,double childSize,double childCount){
    final res = (parentSize - childSize * childCount) / (childCount - 1);
    return double.tryParse(res.toStringAsFixed(2)) ?? 0;
  }
}
