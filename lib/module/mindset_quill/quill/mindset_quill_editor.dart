import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../function.dart';
import 'embed_time.dart';

class MindsetQuillEditor extends StatefulWidget {

  final QuillController quillController;
  final ScrollController scrollController;
  final double? defaultFontSize;
  final int maxTextLength;
  final FocusNode focusNode;
  final bool autoFocus;
  final Document document;

  final SingleCallback<Document> onTextChanged;

  const MindsetQuillEditor({
    super.key,
    required this.quillController,
    required this.scrollController,
    required this.maxTextLength,
    required this.onTextChanged,
    required this.focusNode,
    required this.autoFocus,
    required this.document,
    this.defaultFontSize,
  });

  @override
  State<MindsetQuillEditor> createState() => _MindsetQuillEditorState();
}

class _MindsetQuillEditorState extends State<MindsetQuillEditor> {

  StreamSubscription<DocChange>? sub;
  int offset = 0;

  bool isShowToast = false;
  double fontSize = 20;

  @override
  void didUpdateWidget(covariant MindsetQuillEditor oldWidget) {
    _updateDiary();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    sub ??= widget.quillController.document.changes.listen((change) {
      _checkMaxTextLength();
    });
    widget.quillController.onSelectionChanged = (textSelection){
      _checkTextSelection(textSelection);
    };
    //自动缩小字体
    fontSize = widget.defaultFontSize ?? 20;
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset > 0){
        if(fontSize > 16.0){
          setState(() {
            fontSize -= 2;
          });
        }
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    sub?.cancel();
    sub = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor(
      customStyles: DefaultStyles(
        paragraph: DefaultTextBlockStyle(
            TextStyle(fontSize: fontSize, color: Colors.black),
            const VerticalSpacing(0, 0),
            const VerticalSpacing(0, 0),
            null),
      ),
      controller: widget.quillController,
      readOnly: false,
      autoFocus: widget.autoFocus,
      focusNode: widget.focusNode,
      expands: false,
      minHeight: 100,
      scrollable: true,
      padding: const EdgeInsets.all(0),
      scrollController: widget.scrollController,
      embedBuilders: [
        ...FlutterQuillEmbeds.builders(),
        TimeStampEmbedBuilderWidget()
      ],
    );
  }

  void _updateDiary()async{
    await sub?.cancel();
    sub = null;
    sub ??= widget.quillController.document.changes.listen((change) {
      _checkMaxTextLength();
    });
    widget.quillController.onSelectionChanged = (textSelection){
      _checkTextSelection(textSelection);
    };
  }

  void _checkTextSelection(TextSelection textSelection){
    // Log().i("base : ${textSelection.base} , offset : ${textSelection.baseOffset}");
    setState(() {
      offset = textSelection.baseOffset;
    });
  }

  void _checkMaxTextLength()async{
    widget.onTextChanged(widget.quillController.document);
    int documentLength = widget.quillController.document.length;
    if (documentLength > widget.maxTextLength) {
      final addLength = documentLength - widget.maxTextLength;
      final latestIndex = offset - addLength;
      try{
        widget.quillController.replaceText(
          latestIndex,
          addLength,
          '',
          TextSelection.collapsed(offset: latestIndex),
        );
      } catch(e){
        print("error : $e");
      }
    }
  }
}
