import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:td_flutter/home/home_logic.dart';
import 'package:td_flutter/home/home_state.dart';
import 'package:td_flutter/module/image_test/mindset_crop_rect/crop_rect_point_widget.dart';
import 'package:td_flutter/module/image_test/mindset_crop_rect/crop_rect_widget.dart';
import 'package:td_flutter/module/image_test/mindset_crop_rect/draw_crop_image.dart';
import 'package:td_flutter/module/image_test/mindset_crop_rect/crop_rect.dart';

import 'image_test_logic.dart';

class ImageTestPage extends StatefulWidget {
  ImageTestPage({Key? key}) : super(key: key);

  @override
  State<ImageTestPage> createState() => _ImageTestPageState();
}

class _ImageTestPageState extends State<ImageTestPage> {
  final logic = Get.put(ImageTestLogic());

  final state = Get
      .find<ImageTestLogic>()
      .state;

  final reKey = GlobalKey();

  Uint8List? cropData;

  late final String tempPath;
  File? imageFile;
  Offset? _center;

  double rectWidth = 300;
  double rectHeight = 300;


  Offset topLeftOffset = Offset.zero;
  Offset bottomRightOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _center = Get
        .find<HomeLogic>()
        .state
        .center;
    print("center : $_center ");
    () async {
      tempPath = (await getTemporaryDirectory()).path;
    print("tempPath : $tempPath");
    imageFile = File("$tempPath/test.png"
    );
  }
    (
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: WillPopScope(
        onWillPop: () async {
          if (state.isShowCropPointRect.value || state.isShowCropRect.value) {
            state.isShowCropRect.value = false;
            state.isShowCropPointRect.value = false;
            return false;
          }
          return true;
        },
        child: Stack(
            children: [
              RepaintBoundary(
                  key: reKey,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: AspectRatio(
                        aspectRatio: 16.0 / 9.0,
                        child: Image(image: AssetImage("assets/cat/1.png"),
                          fit: BoxFit.fill,)),
                  )
              ),
              _buildCenter(),
              _buildCustom(),
              _buildCropButton(),
            ]
        ),
      ),
    );
  }

  Center _buildCenter() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () => state.isShowCropRect.value = true,
              child: Text("cropRect")),
          ElevatedButton(
              onPressed: () => state.isShowCropPointRect.value = true,
              child: Text("cropPointRect")),
        ],
      ),
    );
  }

  Widget _buildCustom() {
    return Obx(() {
      if (state.isShowCropRect.value) {
        return CropRectWidget(positionCallback: (topLeft)=> topLeftOffset = topLeft);
      }
      if (state.isShowCropPointRect.value) {
        return CropRectPointWidget(
            positionCallback: (topLeft,bottomRight){
              topLeftOffset = topLeft;
              bottomRightOffset = bottomRight;
            },
          defaultWidth: 300,
          defaultHeight: 300,
          windowCenter: _center!,
        );
      }
      return const SizedBox();
    });
  }

  Widget _buildCropButton() {
    return Obx(() {
      if(state.isShowCropPointRect.value || state.isShowCropRect.value){
        return Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 100, left: 100),
          child: Row(
            children: [
              ElevatedButton(onPressed: () async {
                // _showCropPaint();
                _showCropDialog();
              }, child: Text("拍照")),
              ElevatedButton(onPressed: () {
                state.isShowCropPointRect.value = false;
                state.isShowCropRect.value = false;
                }, child: Text("取消")),
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }

  void _showCropPaint() async {
    try {
      final double dpr = View
          .of(context)
          .devicePixelRatio;
      RenderRepaintBoundary boundary =
      reKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image uiImage = await boundary.toImage(pixelRatio: dpr);
      // double leftX = _center!.dx - rectWidth / 2 + xPos;
      // double topY = _center!.dy - rectHeight / 2 + yPos;
      // print("leftX: $leftX, topY: $topY");
      double x = topLeftOffset.dx * dpr;
      double y = topLeftOffset.dy * dpr;
      double imageWidth = rectWidth * dpr;
      double imageHeight = rectHeight * dpr;
      print(
          "x: $x, y: $y, imageWidth: $imageWidth, imageHeight: $imageHeight,dpr : $dpr");
      Rect cropRect = Rect.fromLTWH(x, y, imageWidth, imageHeight);

      await SmartDialog.show(
          useAnimation: false,
          builder: (_) =>
              Container(
                width: rectWidth + 20,
                height: rectHeight + 20,
                child:
                CustomPaint(
                  painter: DrawCropImage(uiImage, cropRect),
                ),
              )
      );
    }
    catch (e) {
      print("error : $e");
    }
  }

  void _showCropDialog() async {
    rectWidth = bottomRightOffset.dx - topLeftOffset.dx;
    rectHeight = bottomRightOffset.dy - topLeftOffset.dy;
    final double dpr = View
        .of(context)
        .devicePixelRatio;
    int x = (topLeftOffset.dx * dpr).toInt();
    int y = (topLeftOffset.dy * dpr).toInt();
    int imageWidth = (rectWidth * dpr).toInt();
    int imageHeight = (rectHeight * dpr).toInt();
    print(
        "x: $x,y: $y,width: $rectWidth,height: $rectHeight,rawLeft : ${topLeftOffset.dx},rawRight:${topLeftOffset.dy}");
    try {
      RenderRepaintBoundary boundary =
      reKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image uiImage = await boundary.toImage(pixelRatio: dpr);
      ByteData? byteData = await uiImage.toByteData(
          format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      String path = "$tempPath/test_${DateTime.timestamp()}.png";
      print("pngBytes: ${pngBytes == null}");
      img.Command cmd = img.Command()
        ..decodeImage(pngBytes!)
        ..copyCrop(x: x, y: y, width: imageWidth, height: imageHeight)
        ..writeToFile(path);
      cmd = await cmd.execute();
      File file = File(path);
      if (file.existsSync()) {
        await SmartDialog.show(builder: (_) =>
            Container(
              width: rectWidth + 20,
              height: rectHeight + 20,
              child: Image(image: FileImage(file)),
            )
        );
      }
    }
    catch (e) {
      print("error : $e");
    }
    setState(() {

    });
  }


  void cropImage(int x, int y, int width, int height) async {
    try {
      RenderRepaintBoundary boundary =
      reKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image uiImage = await boundary.toImage(pixelRatio: 3.0);
      int width = uiImage.width;
      int height = uiImage.height;
      print("width: ${uiImage.width},height: ${uiImage.height}");
      ByteData? byteData = await uiImage.toByteData(
          format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      print("pngBytes: ${pngBytes == null}");
      img.Command cmd = img.Command()
        ..decodeImage(pngBytes!)
        ..copyCrop(x: width ~/ 2, y: width ~/ 2, width: width, height: height)
        ..writeToFile("$tempPath/test.png");
      cmd = await cmd.execute();
      cropData = await cmd.getBytes();
      print("cropData: ${cropData == null}");
      setState(() {

      });
    }
    catch (e) {
      print("error : $e");
    }
  }
}

enum ExpandRect {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight
}
