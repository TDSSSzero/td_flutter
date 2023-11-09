import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class MindsetQuillState {

  Document doc = Document();
  final int maxDocumentLength = 2001;
  final currentDocumentLength = 1.obs;

  MindsetQuillState() {
    ///Initialize variables
  }
}
