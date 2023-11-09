import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MyQuillStyle{

  static final DefaultStyles styles = DefaultStyles(
      paragraph: DefaultTextBlockStyle(
          const TextStyle(fontSize: 20),
          const VerticalSpacing(0, 0),
          const VerticalSpacing(0, 0),
          null
      ),
  );
}
