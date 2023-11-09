import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import 'mindset_quill_state.dart';

class MindsetQuillLogic extends GetxController {
  final MindsetQuillState state = MindsetQuillState();


  final QuillController quillController = QuillController.basic();
  final ScrollController quillScrollController = ScrollController();
  final ScrollController listViewScrollController = ScrollController();

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onDiaryChanged(Document doc){
    print(" onDiaryChanged ${doc.toPlainText()}");
    state.currentDocumentLength.value = doc.length;
  }

}
