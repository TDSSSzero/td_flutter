import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:get/get.dart';
import 'package:td_flutter/module/mindset_quill/quill/mindset_quill_editor.dart';
import 'package:td_flutter/module/mindset_quill/quill/mindset_quill_toolbar.dart';
import 'package:td_flutter/module/quill_test/embed_test.dart';
import 'package:td_flutter/module/quill_test/my_quill_toolbar.dart';

import 'mindset_quill/mindset_auto_text.dart';
import 'quill_test_logic.dart';

class QuillTestPage extends StatefulWidget {
  QuillTestPage({Key? key}) : super(key: key);

  @override
  State<QuillTestPage> createState() => _QuillTestPageState();
}

class _QuillTestPageState extends State<QuillTestPage> {
  final logic = Get.put(QuillTestLogic());

  final state = Get
      .find<QuillTestLogic>()
      .state;
  final textKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(onPressed: () {
                        logic.minSize.value = logic.minSize.value - 1.0;
                      }, icon: Icon(Icons.remove_circle)),
                      Text("字体最小值：${logic.minSize.value}",),
                    ],);
                }),
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("当前字体大小：${logic.fontSize.value}"),
                      Text("是否出界：${logic.isOut.value}",
                        style: TextStyle(color: Colors.red),),
                    ],);
                }),
                Obx(() {
                  return Text("当前长度：${logic.currentLength.value} / ${logic.limit}");
                }),
                SizedBox(height: 20,),
                Container(
                  width: 200,
                  height: 150,
                  color: Colors.black12,
                  child: Obx(() {
                    return MindsetAutoText(
                      logic.textData.value,
                      textKey: textKey,
                      style: TextStyle(fontSize: logic.fontSize.value),
                      minFontSize: logic.minSize.value,
                    );
                  }),
                ),
                Container(
                  color: Colors.black26,
                  width: 200,
                  height: 150,
                  child: MindsetQuillEditor(
                    testKey: state.editorKey,
                      quillController: logic.controller,
                      scrollController: logic.scrollController,
                      maxTextLength: logic.limit,
                      onTextChanged: (doc){
                        // print("doc : ${doc.toPlainText()}");
                      },
                      focusNode: state.quillNode,
                      autoFocus: false,
                      document: quill.Document(),
                    defaultFontSize: 20,
                  ),
                ),
                ElevatedButton(key: state.editorKey,onPressed: logic.onGetKey, child: Text("key")),
                // ElevatedButton(onPressed: logic.onSave, child: Text("save")),
                // ElevatedButton(onPressed: logic.onRestore, child: Text("restore")),
                KeyboardVisibilityBuilder(builder: (_, isShow) =>
                    Expanded(
                        flex: 1,
                        child: isShow
                            ? MindsetQuillBar(controller: logic.controller)
                            : const SizedBox()
                    )
                ),
              ],
            )));
  }

  void test() {
    if (textKey != null) {
      Text textWidget = textKey.currentWidget as Text;
      print("current fontSize: ${textWidget.style!.fontSize}");
    }
  }
}
