import 'dart:math';

import 'package:flutter/material.dart';

class MoodHandle extends StatefulWidget {

  final double size;
  final double handleRadius;
  const MoodHandle({super.key,this.size = 160,this.handleRadius = 20.0});

  @override
  State<MoodHandle> createState() => _MoodHandleState();
}

class _MoodHandleState extends State<MoodHandle> {

  final ValueNotifier<Offset> _offset = ValueNotifier(Offset.zero);
  final ValueNotifier<Offset> _globalOffset = ValueNotifier(Offset.zero);

  final colors = [
    Colors.red,Colors.yellow,Colors.blue,Colors.green,
    Colors.lightBlueAccent,Colors.greenAccent,
    Colors.amber,Colors.brown,Colors.deepPurpleAccent,Colors.cyanAccent,
  ];

  final moodOffsets = [];

  final columnKey = GlobalKey();
  final parentSize = 300.0;
  final childSize = 50.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Future.delayed(const Duration(seconds: 1),_getOffsets);
      _calculateOffsets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              width: parentSize,
              height: parentSize,
              alignment: Alignment.center,
              child: Column(
                key: columnKey,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) => _buildMoodItem(index+1)),
              ),
            ),
            GestureDetector(
              onPanEnd: reset,
              onPanUpdate: parser,
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _HandlePainter(
                    color: Colors.green,
                    handleR:widget.handleRadius,
                    offset: _offset
                ),
              ),
            ),
          ],
        ),
        ElevatedButton(onPressed: (){
          _calculateOffsets();
        }, child: const Text("calculate"))
      ],
    );
  }
  
  Widget _buildMoodItem(int row){
    List<Widget> children = [];
    switch(row){
      case 1: children = colors.take(4).map((e) =>
          Container(width: childSize,height: childSize,color: e)).toList();
      case 2: children = colors.skip(4).take(2).map((e) =>
          Container(width: childSize,height: childSize,color: e)).toList();
      case 3: children = colors.skip(6).take(4).map((e) =>
          Container(width: childSize,height: childSize,color: e)).toList();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  void reset(DragEndDetails details){
    print("end global : ${_globalOffset.value}");
    print("end local : ${_offset.value}");
    _offset.value = Offset.zero;
  }

  void parser(DragUpdateDetails details) {
    final offset = details.localPosition;
    _globalOffset.value = details.globalPosition;
    double dx = 0.0;
    double dy = 0.0;
    dx = offset.dx - widget.size / 2;
    dy = offset.dy - widget.size / 2;
    // print("details pos : $offset");
    var rad = atan2(dx, dy);
    // print("rad : $rad");
    if (dx < 0) {
      rad += 2 * pi;
    }
    var bgR = widget.size / 2 - widget.handleRadius;
    var thta = rad - pi / 2; //旋转坐标系90度
    // print("thta : $thta");
    var d = sqrt(dx * dx + dy * dy);
    if (d > bgR) {
      dx = bgR * cos(thta);
      dy = -bgR * sin(thta);
    }
    _offset.value = Offset(dx, dy);
  }

  void _calculateOffsets(){
    List<Offset> local = [];
    List<Offset> global = [];
    RenderBox renderBox;
    // Traverse each child of the Column
    final rowElements = [];
    columnKey.currentContext?.visitChildElements((element) {
      rowElements.add(element);
      // Get the RenderBox of the child
      renderBox = element.renderObject as RenderBox;

      // Get the position of the child in global coordinates
      Offset globalPosition = renderBox.localToGlobal(Offset.zero);
      double x = globalPosition.dx;
      double y = globalPosition.dy;

      // print('Position: ($x, $y)');
    });
    if(rowElements.isEmpty) return;
    for (var i = 0; i < rowElements.length; ++i) {
      Element row = rowElements[i];
      row.visitChildElements((element) {
        renderBox = element.renderObject as RenderBox;

        // Get the position of the child in global coordinates
        Offset globalPosition = renderBox.localToGlobal(Offset.zero);
        double x = globalPosition.dx;
        double y = globalPosition.dy;
        local.add(renderBox.globalToLocal(Offset.zero));
        global.add(Offset(x,y));

      });
    }
    // final rowl1 = local.take(4);
    // final rowl2 = local.skip(4).take(2);
    // final rowl3 = local.skip(6).take(4);
    final rowg1 = global.take(4);
    final rowg2 = global.skip(4).take(2);
    final rowg3 = global.skip(6).take(4);
    // print('local row 1 offsets : $rowl1');
    // print('local row 2 offsets : $rowl2');
    // print('local row 3 offsets : $rowl3');
    print('global row 1 offsets : $rowg1');
    print('global row 2 offsets : $rowg2');
    print('global row 3 offsets : $rowg3');
  }

}

class _HandlePainter extends CustomPainter{

  final Paint _paint = Paint();
  double handleR;
  final ValueNotifier<Offset> offset;
  final Color color;

  _HandlePainter({required this.handleR, required this.offset, this.color = Colors.blue})
      : super(repaint: offset);

  @override
  void paint(Canvas canvas, Size size) {
    // print("size : $size");
    canvas.clipRect(Offset.zero & size);
    final bgR = size.width / 2 - handleR;
    // print("bgR : $bgR");
    canvas.translate(size.width / 2, size.height / 2);
    _paint..style = PaintingStyle.fill..color = Colors.greenAccent.withOpacity(0.2);
    canvas.drawCircle(Offset.zero, bgR, _paint);
    _paint.color = color.withAlpha(150);
    canvas.drawCircle(offset.value, handleR, _paint);
    _paint..style = PaintingStyle.stroke..color = Colors.red;
    canvas.drawLine(Offset.zero,offset.value,_paint);
    canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: size.width, height: size.height), _paint);
  }

  @override
  bool shouldRepaint(_HandlePainter oldDelegate) =>
      oldDelegate.offset != offset ||
          oldDelegate.color != color ||
          oldDelegate.handleR != handleR;

}