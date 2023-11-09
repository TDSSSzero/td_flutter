import 'dart:math';

import 'package:flutter/material.dart';

class CircleFlow extends StatefulWidget {
  final List<Widget> children;

  CircleFlow({required this.children});

  @override
  State<CircleFlow> createState() => _CircleFlowState();
}

class _CircleFlowState extends State<CircleFlow> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  double rad = 0.0;

  @override
  void initState() {
    _controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 3000))
      ..addListener(() => setState(() {
        rad = _controller.value * pi * 2;
      }));
    _controller.forward();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _CircleFlowDelegate(rad),
      children: widget.children,
    );
  }
}

class _CircleFlowDelegate extends FlowDelegate {

  double rad;

  _CircleFlowDelegate(this.rad);

  @override //绘制孩子的方法
  void paintChildren(FlowPaintingContext context) {
    double radius = context.size.shortestSide / 2;
    var count = context.childCount;
    var perRad = 2 * pi / count;
    for (int i = 0; i < count; i++) {
      // print(i);
      var cSizeX = context.getChildSize(i)!.width / 2;
      var cSizeY = context.getChildSize(i)!.height / 2;

      var offsetX = (radius - cSizeX) * cos(i * perRad + rad) + radius;
      var offsetY = (radius - cSizeY) * sin(i * perRad + rad) + radius;
      context.paintChild(i,
          transform: Matrix4.translationValues(
              offsetX - cSizeX, offsetY - cSizeY, 0.0));
    }
  }
  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return true;
  }
}
