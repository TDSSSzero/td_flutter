import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class TouchBurstFlow extends StatefulWidget {
  final List<Widget> children;
  final Widget? menu;

  const TouchBurstFlow({super.key, required this.children, this.menu});

  @override
  _TouchBurstFlowState createState() => _TouchBurstFlowState();
}

class _TouchBurstFlowState extends State<TouchBurstFlow> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _rad = 0.0;
  bool _closed = true;
  final key = GlobalKey();

  Offset endOffset = Offset(25, 25);
  final double iconSize = 50;

  int touchIndex = -1;
  DateTime? startPressTime;
  DateTime? endPressTime;
  bool isOpen = false;
  static const longTime = 600;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this)
      ..addListener(() => setState(
          () => _rad = (_closed ? (_controller.value) : 1 - _controller.value)))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _closed = !_closed;
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int count = widget.children.length;
        // List<_Bound> boundList = getChildrenBound(count,constraints.maxWidth);
        return Flow(
          key: key,
          delegate: _CircleFlowDelegate(_rad),
          children: [
            ...widget.children,
            Listener(
                onPointerDown: (PointerDownEvent downEvent) {
                  startPressTime = DateTime.now();
                  print('onPointerDown endtime : ${endPressTime == null}');
                  Timer(const Duration(milliseconds: longTime),(){
                    if(endPressTime == null){
                      _controller.reset();
                      _controller.forward();
                      endOffset = Offset(downEvent.delta.dx, downEvent.delta.dy);
                      isOpen = true;
                    }else{
                      endPressTime = null;
                    }
                  });
                },
                onPointerUp: (PointerUpEvent upEvent) {
                  endPressTime = DateTime.now();
                  int index = judgeUpIndex(endOffset, getChildrenBound(count,constraints.maxWidth));
                  print('index $index');
                  if(index != -1){
                    SmartDialog.showToast("you touched $index");
                  }
                  if(endPressTime!.difference(startPressTime!).inMilliseconds > longTime && isOpen == true){
                    _controller.reset();
                    _controller.forward();
                    endOffset = Offset(25, 25);
                    setState(() {
                      touchIndex = -1;
                    });
                    isOpen = false;
                    endPressTime = null;
                  }
                },
                onPointerMove: (PointerMoveEvent pointerMoveEvent) {
                  double newOffsetX = endOffset.dx + pointerMoveEvent.delta.dx;
                  double newOffsetY = endOffset.dy + pointerMoveEvent.delta.dy;
                  if(isOpen == true){
                    setState(() {
                      endOffset = Offset(newOffsetX, newOffsetY);
                    });
                    int index = judgeUpIndex(endOffset, getChildrenBound(count,constraints.maxWidth));
                    if(index != -1){
                      setState(() {
                        touchIndex = index;
                      });
                    }
                  }
                },
                child: CustomPaint(
                  painter: LineCustomPainter(key, endOffset,touchIndex,getChildrenBound(count,constraints.maxWidth)),
                  child: widget.menu,
                ))
          ],
        );
      },
    );
  }

  bool checkIsNeedOpen(){
    bool isNeedOpen = false;

    return false;
  }

  List<_Bound> getChildrenBound(int count,double width){
    double diff = width / 2 - iconSize / 2;
    List<_Bound> list = [];
    double radius = width / 2;
    var perRad = 2 * pi / count;
    for (int index = 0; index < count; index++) {
      // print(i);
      var cSizeX = iconSize / 2;
      var cSizeY = iconSize / 2;
      var offsetX = _rad * (radius - cSizeX) * cos(index * perRad) + radius;
      var offsetY = _rad * (radius - cSizeY) * sin(index * perRad) + radius;
      var diffCenterX = (offsetX - diff).round();
      var diffCenterY = (offsetY - diff).round();
      // if (index == 0 || index == 0) {
      //   print("$index icon offset: x = ${diffCenterX}  y = ${diffCenterY}");
      //   print("$index icon offset: x = ${width}  y = ${diff}");
      // }
      list.add(_Bound(diffCenterX-cSizeX, diffCenterX+cSizeX, diffCenterY-cSizeY, diffCenterY+cSizeY,index));
    }
    // print(list);
    return list;
  }

  int judgeUpIndex(Offset offset,List<_Bound> list){
    int index = -1;
    double x = offset.dx;
    double y = offset.dy;
    print('x $x,y $y');
    for(int i = 0;i<list.length;i++){
      _Bound b = list[i];
      print(b);
      if (b.minX <= x && b.maxX >= x && b.minY <= y && b.maxY >= y) {
        return i;
      }
    }
    return index;
  }

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

class LineCustomPainter extends CustomPainter {
  GlobalKey key;
  Offset endOffset;
  // Offset startOffset;
  var paintLine;
  int touchIndex;
  List<_Bound> boundList;

  LineCustomPainter(this.key, this.endOffset,this.touchIndex,this.boundList) {
    paintLine = Paint();
    paintLine
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // print("paint x : ${endOffset.dx} y : ${endOffset.dy}");
    // Offset center = getWidgetCenter();
    Offset center = Offset(25, 25);
    // print("center x : ${center.dx} y : ${center.dy}");
    canvas.drawLine(endOffset, center, paintLine);
    // Paint rectPaint = Paint();
    // rectPaint.color = Colors.lightBlue;
    // canvas.drawRect(
    //     Rect.fromCenter(center: Offset(150, 25), width: 50, height: 50),
    //     rectPaint);
    // canvas.drawRect(
    //     Rect.fromCenter(center: Offset(-100, 25), width: 50, height: 50),
    //     rectPaint);
    // canvas.drawRect(
    //     Rect.fromCenter(center: Offset(87.5, 133), width: 50, height: 50),
    //     rectPaint);
    // canvas.drawRect(
    //     Rect.fromCenter(center: Offset(-37.5, -83.5), width: 50, height: 50),
    //     rectPaint);
    if(touchIndex != -1){
      canvas.drawRect(Rect.fromCenter(center: Offset(boundList[touchIndex].minX+40, boundList[touchIndex].minY+40), width: 52, height: 52),
          Paint()
            ..style = PaintingStyle.stroke
          ..color = Colors.yellowAccent
          ..strokeWidth = 3
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Offset getWidgetCenter() {
    // 获取BuildContext
    BuildContext? context = key.currentContext;
    if (context == null) return Offset.zero;

    // 获取RenderBox
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    if (renderBox == null) return Offset.zero;

    // 获取Widget中心点坐标
    Offset center = renderBox.localToGlobal(renderBox.size.center(Offset.zero));
    return center;
  }
}

class _CircleFlowDelegate extends FlowDelegate {
  final double rad;
  _CircleFlowDelegate(this.rad);

  @override //绘制孩子的方法
  void paintChildren(FlowPaintingContext context) {
    double radius = context.size.shortestSide / 2;
    var count = context.childCount - 1;
    var perRad = 2 * pi / count;
    for (int i = 0; i < count; i++) {
      // print(i);
      var cSizeX = context.getChildSize(i)!.width / 2;
      var cSizeY = context.getChildSize(i)!.height / 2;
      // var offsetX = rad * (radius - cSizeX) * cos(i * perRad + rad) + radius;
      // var offsetY = rad * (radius - cSizeY) * sin(i * perRad + rad) + radius;
      var offsetX = rad * (radius - cSizeX) * cos(i * perRad) + radius;
      var offsetY = rad * (radius - cSizeY) * sin(i * perRad) + radius;
      // if (i == 0 || i == 0) {
        print("$i icon offset: x = ${offsetX}  y = ${offsetY}");
        // print("$i icon 125: x = ${radius - cSizeY}");
      // }
      context.paintChild(i,
          transform: Matrix4.translationValues(
              offsetX - cSizeX, offsetY - cSizeY, 0.0));
    }
    context.paintChild(context.childCount - 1,
        transform: Matrix4.translationValues(
            radius - context.getChildSize(context.childCount - 1)!.width / 2,
            radius - context.getChildSize(context.childCount - 1)!.height / 2,
            0.0));
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return true;
  }
}
