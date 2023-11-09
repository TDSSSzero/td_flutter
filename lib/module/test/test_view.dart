import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  @override
  Widget build(BuildContext context) {
    double containerWidth = 200; // 控件宽度
    double containerHeight = 100; // 控件高度
    double fontSize = 20; // 字体大小

    // 要显示的文本
    String text = "一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十";

    // 创建TextPainter对象
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: fontSize)),
      textDirection: TextDirection.ltr,
    );

    // 对TextPainter进行布局
    textPainter.layout(maxWidth: containerWidth);

    // 计算每行能容纳的字符数
    int charsPerLine = (containerWidth / textPainter.width).floor();
    print("每行 : $charsPerLine");

    // 计算需要的总行数
    int totalLines = (text.length / charsPerLine).ceil();
    print(totalLines);
    print(textPainter.height);

    return Scaffold(
      body: Center(
        child: Container(
          width: containerWidth,
          height: containerHeight,
          color: Colors.blue,
          child: Text(text,style: TextStyle(fontSize: 20),),
        ),
      ),
    );
  }

}

