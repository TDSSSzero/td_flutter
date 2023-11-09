import 'package:flutter/material.dart';

class FlowDemo extends StatelessWidget {
  final sides = [60.0, 50.0, 40.0, 30.0];
  final colors = [Colors.red,Colors.yellow,Colors.blue,Colors.green];

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _Delegate(),
      children: sides.map((e) => _buildItem(e)).toList(),
    );
  }

  Widget _buildItem(double e) {
    return Container(
      width: e,
      alignment: Alignment.center,
      height: e,
      color: colors[sides.indexOf(e)],
      child: Text('$e'),
    );
  }
}

class _Delegate extends FlowDelegate{

  @override
  void paintChildren(FlowPaintingContext context) {
    print("父容器尺寸:${context.size}");
    print("孩子个数:${context.childCount}");
    for(int i=0;i<context.childCount;i++){
      print("第$i个孩子尺寸:${context.getChildSize(i)}");
      context.paintChild(i);
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return true;
  }
  
}