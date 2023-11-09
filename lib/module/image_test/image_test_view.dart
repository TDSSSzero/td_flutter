import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:td_flutter/module/image_test/mindset_crop_rect/mindset_crop_rect.dart';

import 'image_test_logic.dart';

class ImageTestPage extends StatefulWidget {
  ImageTestPage({Key? key}) : super(key: key);

  @override
  State<ImageTestPage> createState() => _ImageTestPageState();
}

class _ImageTestPageState extends State<ImageTestPage> {
  final logic = Get.put(ImageTestLogic());

  final state = Get.find<ImageTestLogic>().state;

  final reKey = GlobalKey();

  Uint8List? cropData;

  late final String tempPath;
  File? imageFile;
  ValueNotifier<Offset> _offset = ValueNotifier(Offset.zero);
  var xPos = 0.0;
  var yPos = 0.0;
  final width = 300.0;
  final height = 300.0;
  bool _dragging = false;
  Offset? _center;
  bool _insideRect(double x,double y) {
    print("x:$xPos , y:$yPos");
    return x >= _center!.dx - width / 2 + xPos && x <= _center!.dx + width / 2 + xPos
        && y >= _center!.dy - height / 2 + yPos && y <= _center!.dy + height / 2 + yPos;
  }

  @override
  void initState() {
    super.initState();
    () async {
      tempPath = (await getTemporaryDirectory()).path;
      print("tempPath : $tempPath");
      imageFile = File("$tempPath/test.png");
    }();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    final x = MediaQuery.of(context).size.width / 2;
    final y = MediaQuery.of(context).size.height / 2;
    print("x:$x , y:$y");
    _center = Offset(x, y);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children:[
          RepaintBoundary(
              key: reKey,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: AspectRatio(
                    aspectRatio: 16.0 / 9.0,
                    child: Image(image: AssetImage("assets/cat/1.png"),fit: BoxFit.fill,)),
              )
          ),
          _buildCenter(),
          _buildCustom(),
        ]
      ),
    );
  }

  Center _buildCenter() {
    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: ()async{

              }, child: Text("crop")),
              // cropData == null ? const SizedBox() :
              // Image(image: MemoryImage(cropData!),width: 100,height: 100),
              // !File("$tempPath/test.png").existsSync() ? const SizedBox() :
              // imageFile == null ? const SizedBox() :
              // Image(image: FileImage(File("$tempPath/test.png")),width: 300,height: 300),
            ],
          ),
        );
  }

  Widget _buildCustom(){
    return GestureDetector(
      onPanStart: (details) => _dragging = _insideRect(
        details.localPosition.dx,
        details.localPosition.dy,
      ),
      onPanEnd: (details) {
        _dragging = false;
      },
      onPanUpdate: update,
      child: CustomPaint(
        size: const Size(double.infinity, double.infinity),
        painter: MindsetCropRect(width,height,Offset(xPos, yPos),50),
      ),
    );
  }

  void start(DragStartDetails details,BoxConstraints size){

  }

  void update(DragUpdateDetails details){
    // print("localPosition : ${details.localPosition}");
    if (_dragging) {
      setState(() {
        xPos += details.delta.dx;
        yPos += details.delta.dy;
        // print("dragging offset ${Offset(xPos, yPos)}");
      });
    }
    // _offset.value = details.localPosition;
  }

  void cropImage(int x,int y,int width,int height)async{
    try {
      RenderRepaintBoundary boundary =
      reKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image uiImage = await boundary.toImage(pixelRatio: 3.0);
      int width = uiImage.width;
      int height = uiImage.height;
      print("width: ${uiImage.width},height: ${uiImage.height}");
      ByteData? byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
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
