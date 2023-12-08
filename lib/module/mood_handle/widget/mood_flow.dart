import 'package:flutter/material.dart';
import 'package:td_flutter/module/mood_handle/widget/mood_line_painter.dart';


class MoodFlow extends StatefulWidget {
  final double width;
  final double height;
  final bool isPlay;
  const MoodFlow({super.key,required this.width,required this.height,required this.isPlay});

  @override
  State<MoodFlow> createState() => _MoodFlowState();
}

class _MoodFlowState extends State<MoodFlow> with SingleTickerProviderStateMixin {

  final childSize = 50.0;

  double row1    = 0.0;
  double row2    = 0.0;
  double column1 = 0.0;
  double column2 = 0.0;

  List<_Bound> moodBounds = [];

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
    List<_Bound> childBound = getChildrenBound();
    print("childBound : $childBound");


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
  void didUpdateWidget(covariant MoodFlow oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(widget.isPlay){
      _controller.forward();
      isOpen = true;
    }else{
      _controller.reverse();
      isOpen = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey.withAlpha(66),
      alignment: Alignment.center,
      child: Flow(
        delegate: _MoodFlowDelegate(_value,leftTopOffsets),
        children: [
          ...List.generate(colors.length, (index) => Container(width: 50,height: 50,color: colors[index],child: Text("$index"))),
          Listener(
            onPointerDown: (event) {
              if(!isOpen){
                _controller.forward();
                isOpen = true;
              }
              initOffset = event.localPosition;
              print("initOffset localPosition : $initOffset");
              setState(() {

              });
            },
            onPointerMove: (event) {
              endOffset = event.localPosition;
              setState(() {

              });
              // print("move localPosition: ${event.localPosition}");
              // print("move delta: ${event.delta}");
            },
            onPointerUp: (event) {
              print("up localPosition : $endOffset");
              final judgeOffset = Offset(endOffset.dx - 125 / 2, endOffset.dy - 125 / 2);
              print("judge offset : $judgeOffset");
              int index = judgeUpIndex(judgeOffset, getChildrenBound());
              if(index != -1){
                print("index : $index");
              }
              if(isOpen){
                _controller.reverse();
                isOpen = false;
              }
              initOffset = Offset.zero;
              endOffset = Offset.zero;
              setState(() {

              });
            },
            child: CustomPaint(
              painter: MoodLinePainter(initOffset, endOffset,leftTopOffsets),
              child: Container(
                width: 125,
                height: 125,
                color: Colors.amber,
                child: const SizedBox(),
              ),
            ),
          )
        ],
      ),
    );
  }

  double _getSpacing(double parentSize,double childSize,double childCount){
    final res = (parentSize - childSize * childCount) / (childCount - 1);
    return double.tryParse(res.toStringAsFixed(2)) ?? 0;
  }

  void reset(){

  }

  int _judgeMood(){
    int index = -1;

    return index;
  }

  List<_Bound> getChildrenBound(){
    List<_Bound> list = [];
    for (int i = 0; i < 10; i++) {
      Rect rect = Rect.fromLTWH(leftTopOffsets[i].dx, leftTopOffsets[i].dy, childSize, childSize);
      list.add(_Bound(
          rect.left,
          rect.right,
          rect.top,
          rect.bottom,
          i));
    }
    // print(list);
    return list;
  }

  int judgeUpIndex(Offset offset,List<_Bound> list){
    int index = -1;
    double x = offset.dx;
    double y = offset.dy;
    // print('x $x,y $y');
    for(int i = 0;i<list.length;i++){
      _Bound b = list[i];
      // print(b);
      if (b.minX <= x && b.maxX >= x && b.minY <= y && b.maxY >= y) {
        return i;
      }
    }
    return index;
  }

}


class _MoodFlowDelegate extends FlowDelegate{

  final double _value;
  final List<Offset> leftTopOffsets;
  
  _MoodFlowDelegate(this._value,this.leftTopOffsets);
  
  @override
  void paintChildren(FlowPaintingContext context) {
    // print("父容器尺寸:${context.size}");
    // print("孩子个数:${context.childCount}");
    final count = context.childCount - 1;
    final parentSize = context.size;
    final initOffset = Offset(
        parentSize.width / 2 - context.getChildSize(0)!.width / 2,
        parentSize.height / 2 - context.getChildSize(0)!.height / 2);
    for (int i = 0; i < count; i++) {
      context.paintChild(i,transform: Matrix4.translationValues(
          initOffset.dx + leftTopOffsets[i].dx * _value,
          initOffset.dy + leftTopOffsets[i].dy * _value,
          0));
    }
    //画中心按钮
    context.paintChild(count,transform: Matrix4.translationValues(
        parentSize.width / 2 - context.getChildSize(count)!.width / 2,
        parentSize.height / 2 - context.getChildSize(count)!.height / 2,
        0));
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => true;

}

class _Bound{

  _Bound(this.minX, this.maxX, this.minY, this.maxY, this.index);

  final int index;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  @override
  String toString() {
    return '_Bound{minX: $minX, maxX: $maxX, minY: $minY, maxY: $maxY, index: $index}';
  }
}