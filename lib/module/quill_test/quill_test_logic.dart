import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:td_flutter/common/encrypt_utils.dart';
import 'quill_test_state.dart';

class QuillTestLogic extends GetxController {
  final QuillTestState state = QuillTestState();
  final QuillController controller = QuillController.basic();
  final ScrollController scrollController = ScrollController();

  final minSize = 16.0.obs;
  final fontSize = 20.0.obs;
  Delta before = Delta();
  Delta after = Delta();
  final textData = "".obs;

  final textKey = GlobalKey();

  var json;
  final isOut = false.obs;

  BoxConstraints? size;

  int limit = 200;

  final currentLength = 0.obs;

  @override
  void onReady() {
    super.onReady();
    controller.changes.listen((DocChange change) {
      before = change.before;
      after = change.change;
      // print("before : $before");
      // print("after : $after");
      // print("ChangeSource ${change.source}");
      textData.value = controller.document.toPlainText();
      _calculateFontSize(size, TextStyle(fontSize: fontSize.value));
    });
    scrollController.addListener(() {
      print("offset: ${scrollController.offset}");
      if (scrollController.offset > 0){
        if(fontSize.value > minSize.value){
          fontSize.value -= 2;
        }else{
          isOut.value = true;
        }
      }else{
        isOut.value = false;
      }
    });
    controller.document.changes.listen((DocChange change){
      final documentLength = controller.document.length;
      currentLength.value = documentLength;
      if (documentLength > limit) {
        final latestIndex = limit - 1;
        controller.replaceText(
          latestIndex,
          documentLength - limit,
          '',
          TextSelection.collapsed(offset: latestIndex),
        );
      }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
  void onSave() {
    int length = controller.document.toPlainText().length;
    print(length);
    json = jsonEncode(controller.document.toDelta().toJson());
    print(json);
    print(json.runtimeType);
    json = EncryptUtils.encryptString(json);
    print("加密后 data : $json");
  }
  void onRestore(){
    if(json != null){
      print("解密前 data : $json");
      json = EncryptUtils.decryptString(json);
      print("data : $json");
      controller.document = Document.fromJson(jsonDecode(json));
    }
  }

  void changeMaxText(){

  }

  void _calculateFontSize(BoxConstraints? size, TextStyle? style){
    double height = 100;
    print("fontSize value :${fontSize.value}");
    if(size != null){
      final span = TextSpan(
        style: style ?? const TextStyle(fontSize: 12),
        text: textData.value,
      );
      final textPainter = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      // print("size maxHeight : ${size.maxHeight}");
      print("size maxWidth : ${size.maxWidth}");
      textPainter.layout(maxWidth: size.maxWidth);
      print("textPainter.height : ${textPainter.height}");
      print("textPainter.height > constraints.maxHeight : ${textPainter.height > 100}");
      // if(textPainter.height >= 100-fontSize.value){
      //   isOut.value = true;
      // }else{
      //   isOut.value = false;
      // }
      print("data : ${textData.value}");
    }
  }


}
