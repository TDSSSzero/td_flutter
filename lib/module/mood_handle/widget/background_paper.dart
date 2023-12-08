import 'package:flutter/material.dart';

class BackgroundPaper extends StatelessWidget {

  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final isOpen = false;

  const BackgroundPaper({
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.padding = EdgeInsets.zero
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding,
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.passthrough,
        // alignment: Alignment.bottomCenter,
        children: [
          _buildPaper(context),
          Align(alignment: Alignment.bottomCenter,child: Image(image: AssetImage("assets/theme/home/paper_bottom_plate_bottom.png"),width: width )),
        ],
      ),
    );
  }

  Widget _buildPaper(BuildContext context){
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final topHeight = 169 / dpr;
    final bottomHeight = 421 / dpr;
    final centerHeight = height - topHeight - bottomHeight;
    final width = this.width * 0.95;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(color: isOpen ? Colors.red : null,child: Image(image: AssetImage("assets/theme/home/paper_top.png"),
          width: width,height: topHeight,fit: BoxFit.fill,)),
        Container(color:isOpen ? Colors.blue : null,child: Image(image: AssetImage("assets/theme/home/paper_center.png"),width: width,
            height: centerHeight,fit: BoxFit.fill)),
        Container(color: isOpen ? Colors.greenAccent : null,child: Image(image: AssetImage("assets/theme/home/paper_bottom.png"),width: width,
            height: bottomHeight,fit: BoxFit.fill)),
      ],
    );
  }
}