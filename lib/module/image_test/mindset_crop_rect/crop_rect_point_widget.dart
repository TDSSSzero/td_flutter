import 'package:flutter/material.dart';
import 'package:td_flutter/module/image_test/image_test_view.dart';
import 'package:td_flutter/module/image_test/mindset_crop_rect/crop_rect_point.dart';

//位置回调
typedef RectPositionCallback = void Function(Offset topLeft,Offset bottomRight);

class CropRectPointWidget extends StatefulWidget {

  final RectPositionCallback positionCallback;
  final double defaultWidth;
  final double defaultHeight;
  final Offset windowCenter;
  final double minWidth;
  final double minHeight;

  const CropRectPointWidget({
    super.key,
    required this.positionCallback,
    required this.defaultWidth,
    required this.defaultHeight,
    required this.windowCenter,
    this.minWidth = 100,
    this.minHeight = 100
  });

  @override
  State<CropRectPointWidget> createState() => _CropRectPointWidgetState();
}

class _CropRectPointWidgetState extends State<CropRectPointWidget> {

  final expandSize = 50.0;
  bool _dragging = false;
  ExpandRect? expandRect;
  bool _draggingExpand = false;
  Offset? _center;

  Offset topLeftOffset = Offset.zero;
  Offset bottomRightOffset = Offset.zero;

  double get width => bottomRightOffset.dx - topLeftOffset.dx;
  double get height => bottomRightOffset.dy - topLeftOffset.dy;

  @override
  void initState() {
    super.initState();
    _center = widget.windowCenter;
    final halfWidth = widget.defaultWidth / 2.0;
    final halfHeight = widget.defaultHeight / 2.0;
    topLeftOffset = Offset(_center!.dx - halfWidth, _center!.dy - halfHeight);
    bottomRightOffset = Offset(_center!.dx + halfWidth, _center!.dy + halfHeight);
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
        size: const Size(double.infinity, double.infinity),
        painter: CropRectPoint(
          rect: Rect.fromPoints(topLeftOffset, bottomRightOffset),
          expandRectSize : expandSize,
        ),
      ),
    );
  }

  ExpandRect? _judgeExpandRect(double x,double y){
    double rawLeft = topLeftOffset.dx;
    double rawTop = topLeftOffset.dy;
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
    return x >= topLeftOffset.dx && x <= bottomRightOffset.dx
        && y >= topLeftOffset.dy && y <= bottomRightOffset.dy;
  }

  void update(DragUpdateDetails details){
    final windowWidth = MediaQuery.of(context).size.width;
    final windowHeight = MediaQuery.of(context).size.height;
    if(_draggingExpand){
      _dragging = false;
      if(topLeftOffset.dx < 0.0 || topLeftOffset.dy < 0
          || bottomRightOffset.dx > windowWidth || bottomRightOffset.dy > windowHeight){
        return;
      }
      switch(expandRect!){
        case ExpandRect.topLeft:
          if(details.delta.dx > 0 && width < widget.minWidth){
            // print("topLeft min width");
            return;
          }
          if(details.delta.dy > 0 && height < widget.minHeight){
            // print("topLeft min height");
            return;
          }
          topLeftOffset = Offset(topLeftOffset.dx + details.delta.dx, topLeftOffset.dy + details.delta.dy);
          break;
        case ExpandRect.topRight:
          if(details.delta.dx < 0 && width < widget.minWidth){
            // print("topRight min width");
            return;
          }
          if(details.delta.dy > 0 && height < widget.minHeight){
            // print("topRight min height");
            return;
          }
          topLeftOffset = Offset(topLeftOffset.dx, topLeftOffset.dy + details.delta.dy);
          bottomRightOffset = Offset(bottomRightOffset.dx + details.delta.dx, bottomRightOffset.dy);
          break;
        case ExpandRect.bottomLeft:
          if(details.delta.dx > 0 && width < widget.minWidth){
            // print("bottomLeft min width");
            return;
          }
          if(details.delta.dy < 0 && height < widget.minHeight){
            // print("bottomLeft min height");
            return;
          }
          topLeftOffset = Offset(topLeftOffset.dx + details.delta.dx, topLeftOffset.dy);
          bottomRightOffset = Offset(bottomRightOffset.dx, bottomRightOffset.dy + details.delta.dy);
          break;
        case ExpandRect.bottomRight:
          if(details.delta.dx < 0 && width < widget.minWidth){
            // print("bottomRight min width");
            return;
          }
          if(details.delta.dy < 0 && height < widget.minHeight){
            // print("bottomRight min height");
            return;
          }
          bottomRightOffset = Offset(bottomRightOffset.dx + details.delta.dx, bottomRightOffset.dy + details.delta.dy);
          break;
      }
      setState(() {
      });
    }
    if (_dragging) {
      //水平边界判定
      if(topLeftOffset.dx <= 0 && details.delta.dx < 0){
        topLeftOffset = Offset(0.0, topLeftOffset.dy);
        bottomRightOffset = Offset(width, bottomRightOffset.dy);
      }else if(bottomRightOffset.dx >= windowWidth && details.delta.dx > 0){
        topLeftOffset = Offset(windowWidth - width, topLeftOffset.dy);
        bottomRightOffset = Offset(windowWidth, bottomRightOffset.dy);
      }else{
        topLeftOffset = Offset(topLeftOffset.dx + details.delta.dx, topLeftOffset.dy);
        bottomRightOffset = Offset(bottomRightOffset.dx + details.delta.dx, bottomRightOffset.dy);
      }
      //垂直边界判定
      if(topLeftOffset.dy <= 0 && details.delta.dy < 0){
        topLeftOffset = Offset(topLeftOffset.dx, 0);
        bottomRightOffset = Offset(bottomRightOffset.dx, height);
      }else if(bottomRightOffset.dy >= windowHeight && details.delta.dy > 0){
        topLeftOffset = Offset(topLeftOffset.dx, windowHeight - height);
        bottomRightOffset = Offset(bottomRightOffset.dx, windowHeight);
      }else{
        topLeftOffset = Offset(topLeftOffset.dx, topLeftOffset.dy + details.delta.dy);
        bottomRightOffset = Offset(bottomRightOffset.dx, bottomRightOffset.dy + details.delta.dy);
      }
      setState(() {

      });
    }
    widget.positionCallback(topLeftOffset,bottomRightOffset);
  }
}
