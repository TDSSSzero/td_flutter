import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td_flutter/function.dart';
import 'package:td_flutter/home/home_logic.dart';
import 'package:td_flutter/module/image_test/image_test_view.dart';

import 'crop_rect.dart';

class CropRectWidget extends StatefulWidget {

  final SingleCallback<Offset> positionCallback;

  const CropRectWidget({super.key,required this.positionCallback});

  @override
  State<CropRectWidget> createState() => _CropRectWidgetState();
}

class _CropRectWidgetState extends State<CropRectWidget> {

  var xPos = 0.0;
  var yPos = 0.0;
  double width = 300.0;
  double height = 300.0;
  final expandSize = 50.0;
  Offset? _center;
  double leftOutPosX = 0.0;
  bool _dragging = false;
  ExpandRect? expandRect;
  bool _draggingExpand = false;

  @override
  void initState() {
    _center = Get.find<HomeLogic>().state.center;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        double x = details.localPosition.dx;
        double y = details.localPosition.dy;
        _dragging = _insideRect(x, y);
        expandRect = _judgeExpandRect(x,y);
        _draggingExpand = expandRect != null;
      },
      onPanEnd: (details) {
        _dragging = false;
        _draggingExpand = false;
        setState(() {

        });
      },
      onPanUpdate: update,
      child:
      CustomPaint(
        // size: Size(size.maxWidth, size.minHeight),
        size: const Size(double.infinity, double.infinity),
        painter: CropRect(
            width,
            height,
            Offset(xPos, yPos),
            expandSize,
            expandRect: expandRect
        ),
      ),
    );
  }

  ExpandRect? _judgeExpandRect(double x,double y){
    double rawLeft = _center!.dx - width / 2 + xPos;
    double rawTop = _center!.dy - height / 2 + yPos;
    final halfExpandSize = expandSize / 2;
    if(x >= rawLeft - halfExpandSize && x <= rawLeft + halfExpandSize
        && y >= rawTop - halfExpandSize && y <= rawTop + halfExpandSize
    ){
      expandRect = ExpandRect.topLeft;
      print("judge topLeft");
    } else if(x >= rawLeft + width - halfExpandSize && x <= rawLeft + width + halfExpandSize
        && y >= rawTop - halfExpandSize && y <= rawTop + halfExpandSize){
      print("judge topRight");
      expandRect = ExpandRect.topRight;
    } else if(x >= rawLeft - halfExpandSize && x <= rawLeft + halfExpandSize
        && y >= rawTop + height - halfExpandSize && y <= rawTop + height + halfExpandSize){
      print("judge bottomLeft");
      expandRect = ExpandRect.bottomLeft;
    } else if(x >= rawLeft + width - halfExpandSize && x <= rawLeft + width + halfExpandSize
        && y >= rawTop + height - halfExpandSize && y <= rawTop + height + halfExpandSize){
      print("judge bottomRight");
      expandRect = ExpandRect.bottomRight;
    } else{
      expandRect = null;
    }
    return expandRect;
  }

  bool _insideRect(double x,double y) {
    print("x:$xPos , y:$yPos");
    return x >= _center!.dx - width / 2 + xPos && x <= _center!.dx + width / 2 + xPos
        && y >= _center!.dy - height / 2 + yPos && y <= _center!.dy + height / 2 + yPos;
  }

  void update(DragUpdateDetails details){
    if(_draggingExpand){
      _dragging = false;
      switch(expandRect!){
        case ExpandRect.topLeft:
          width -= details.delta.dx;
          height -= details.delta.dy;
          // topLeftOffset = Offset(topLeftOffset.dx + details.delta.dx, topLeftOffset.dy + details.delta.dy);
          break;
        case ExpandRect.topRight:
          width += details.delta.dx;
          height -= details.delta.dy;
          break;
        case ExpandRect.bottomLeft:
          width -= details.delta.dx;
          height += details.delta.dy;
          break;
        case ExpandRect.bottomRight:
          width += details.delta.dx;
          height += details.delta.dy;
          break;
      }
      if(width < 100){
        width = 100;
      }
      if(height < 100){
        height = 100;
      }
      setState(() {
      });
    }
    if (_dragging) {
      final windowWidth = MediaQuery.of(context).size.width;
      final windowHeight = MediaQuery.of(context).size.height;
      double rawLeft = _center!.dx - width / 2 + xPos;
      double rawTop = _center!.dy - height / 2 + yPos;
      // print("raw left $rawLeft");
      if(rawLeft < 0){
        xPos = -(windowWidth / 2 - width / 2);
      }else if(rawLeft + width > windowWidth){
        xPos = windowWidth / 2 - width / 2;
      }else{
        xPos += details.delta.dx;
      }
      if(rawTop < 0){
        yPos = -(windowHeight / 2 - height / 2);
      }else if(rawTop + height > windowHeight){
        yPos = windowHeight / 2 - height / 2;
      }else{
        yPos += details.delta.dy;
      }
      setState(() {
        widget.positionCallback(Offset(rawLeft, rawTop));
      });
    }
  }
}
