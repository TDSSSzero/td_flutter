import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import '../embed_test.dart';
import '../my_style.dart';

class TDQuill extends StatefulWidget {
  final QuillController controller;

  const TDQuill({super.key,required this.controller});

  @override
  State<TDQuill> createState() => _TDQuillState();
}

class _TDQuillState extends State<TDQuill> {

  late final QuillController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,size){
      return Container(
        color: Colors.black26,
        width: 200,
        height: 200,
        child: QuillEditor(
          customStyles: MyQuillStyle.styles,
          minHeight: 100,
          maxHeight: 200,
          maxContentWidth: 200,
          controller: controller,
          readOnly: false,
          autoFocus: true,
          focusNode: FocusNode(),
          expands: false,
          padding: const EdgeInsets.all(10),
          scrollable: false,
          scrollController: ScrollController(),
          embedBuilders: [
            ...FlutterQuillEmbeds.builders(),
            TimeStampEmbedBuilderWidget()
          ],
        ),
      );
    });
  }
}
