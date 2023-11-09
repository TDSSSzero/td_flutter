import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:td_flutter/module/mindset_quill/quill/mindset_quill_editor.dart';
import 'package:td_flutter/module/mindset_quill/quill/mindset_quill_toolbar.dart';

import '../../common/fonts.dart';
import 'mindset_quill_logic.dart';

class MindsetQuillPage extends StatelessWidget {
  MindsetQuillPage({Key? key}) : super(key: key);

  final logic = Get.put(MindsetQuillLogic());
  final state = Get.find<MindsetQuillLogic>().state;

  @override
  Widget build(BuildContext context) {
    // double keyHeight = 0.0;
    // if(MediaQuery.of(context).viewInsets.bottom!=0.0){
    //   //键盘高度是会变的，键盘隐藏的时候会返回0，所以为0是不赋值
    //   keyHeight = MediaQuery.of(context).viewInsets.bottom;
    // }
    // print("keyHeight: $keyHeight");
    return Scaffold(
        body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 60, left: 40,right: 40),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    color: Colors.amber.shade100),
                width: 500,
                height: 900,
                child: ListView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                      .manual,
                  controller: logic.listViewScrollController,
                  children: [
                    _buildWriteArea(),
                    _buildTestMenu(),
                  ],
                ),
              ),
              _buildToolbar(),
            ]
        )
    );
  }

  Widget _buildWriteArea() {
    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.black12,
            height: 340,
            child: _buildQuillEditor(),
          ),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("${state.currentDocumentLength.value - 1}"),
                const Text("/"),
                Text("${state.maxDocumentLength - 1}")
              ],);
          }),
        ],
      ),
    );
  }

  Widget _buildQuillEditor() {
    return MindsetQuillEditor(
      quillController: logic.quillController,
      scrollController: logic.quillScrollController,
      maxTextLength: 2001,
      onTextChanged: logic.onDiaryChanged,
      focusNode: FocusNode(),
      autoFocus: false,
      document: state.doc,
      defaultFontSize: 20,
    );
  }


  Widget _buildToolbar() {
    return KeyboardVisibilityBuilder(builder: (context, isShow) {
      // isShow ? logic.goLast() : null;
      // print("keyboard : $isShow");
      return
        Container(
          color: isShow ? Colors.grey : Colors.transparent,
          height: 40,
          width: double.infinity,
          child: isShow
              ? MindsetQuillBar(
            controller: logic.quillController,
          )
              : const SizedBox())
        // MindsetQuillBar(
        //   controller: logic.quillController,
        // )
      ;
    });
  }


  Widget _buildTestMenu(){
    return Builder(
      builder: (context) {
        return Column(
          children: [
            GestureDetector(
              onTap: ()=>_showMenu(context),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.black,
              ),
            ),
            Text("dream test , Dream Test",style: TextStyle(fontFamily: Fonts.dream),),
            Text("efectiva test , Efectiva Test",style: TextStyle(fontFamily: Fonts.efectiva),),
            Text("floane test , Floane Test",style: TextStyle(fontFamily: Fonts.floane),),
          ],
        );
      }
    );
  }

  void _showMenu(BuildContext context){
    print("show menu");
    SmartDialog.showAttach(
      maskColor: Colors.black,
        targetContext: context,
        alignment: Alignment.topCenter,
        builder: (_) => Container(
          width: 300,
          height: 50,
          color: Colors.purpleAccent,
          child: Text("test"),
        )
    );
  }

}
