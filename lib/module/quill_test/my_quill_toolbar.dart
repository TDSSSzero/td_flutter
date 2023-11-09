import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/translations.dart';
import 'package:intl/intl.dart';

import 'embed_test.dart';

///需要 选择字体、字体颜色、加粗、下划线、斜体、删除、有序、无序列表、添加时间
class MyQuillBar extends StatefulWidget {
  final QuillController controller;
  const MyQuillBar({super.key,required this.controller});

  @override
  State<MyQuillBar> createState() => _MyQuillBarState();
}

class _MyQuillBarState extends State<MyQuillBar> {

  late final controller;

  final double toolbarIconSize = 18;
  double toolbarSectionSpacing = kToolbarSectionSpacing;
  WrapAlignment toolbarIconAlignment = WrapAlignment.center;
  WrapCrossAlignment toolbarIconCrossAlignment = WrapCrossAlignment.center;
  List<QuillCustomButton> customButtons = const [];
  Map<String, String>? fontFamilyValues;
  Locale locale = const Locale('zh');
  VoidCallback? afterButtonPressed;
  List<EmbedButtonBuilder>? embedButtons;

  //default button tooltips
  final buttonTooltips =
      <ToolbarButtons, String>{
        ToolbarButtons.undo: 'Undo'.i18n,
        ToolbarButtons.redo: 'Redo'.i18n,
        ToolbarButtons.fontFamily: 'Font family'.i18n,
        ToolbarButtons.fontSize: 'Font size'.i18n,
        ToolbarButtons.bold: 'Bold'.i18n,
        ToolbarButtons.subscript: 'Subscript'.i18n,
        ToolbarButtons.superscript: 'Superscript'.i18n,
        ToolbarButtons.italic: 'Italic'.i18n,
        ToolbarButtons.small: 'Small'.i18n,
        ToolbarButtons.underline: 'Underline'.i18n,
        ToolbarButtons.strikeThrough: 'Strike through'.i18n,
        ToolbarButtons.inlineCode: 'Inline code'.i18n,
        ToolbarButtons.color: 'Font color'.i18n,
        ToolbarButtons.backgroundColor: 'Background color'.i18n,
        ToolbarButtons.clearFormat: 'Clear format'.i18n,
        ToolbarButtons.leftAlignment: 'Align left'.i18n,
        ToolbarButtons.centerAlignment: 'Align center'.i18n,
        ToolbarButtons.rightAlignment: 'Align right'.i18n,
        ToolbarButtons.justifyAlignment: 'Justify win width'.i18n,
        ToolbarButtons.direction: 'Text direction'.i18n,
        ToolbarButtons.headerStyle: 'Header style'.i18n,
        ToolbarButtons.listNumbers: 'Numbered list'.i18n,
        ToolbarButtons.listBullets: 'Bullet list'.i18n,
        ToolbarButtons.listChecks: 'Checked list'.i18n,
        ToolbarButtons.codeBlock: 'Code block'.i18n,
        ToolbarButtons.quote: 'Quote'.i18n,
        ToolbarButtons.indentIncrease: 'Increase indent'.i18n,
        ToolbarButtons.indentDecrease: 'Decrease indent'.i18n,
        ToolbarButtons.link: 'Insert URL'.i18n,
        ToolbarButtons.search: 'Search'.i18n,
      };

  //default font family values
  final fontFamilies =
      {
        'Sans Serif': 'sans-serif',
        'Serif': 'serif',
        'Monospace': 'monospace',
        'Ibarra Real Nova': 'ibarra-real-nova',
        'SquarePeg': 'square-peg',
        'Nunito': 'nunito',
        'Pacifico': 'pacifico',
        'Roboto Mono': 'roboto-mono',
        'Clear'.i18n: 'Clear'
      };
  QuillIconTheme? iconTheme;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = widget.controller;
  }


  @override
  Widget build(BuildContext context) {
    return
      // QuillToolbar.basic(
      //     controller: widget.controller,
      //   showUndo: false,
      //   showRedo: false,
      //   showFontSize: false,
      //   showSubscript: false,
      //   showSuperscript: false,
      //
      // )
      ///需要 选择字体、字体颜色、加粗、下划线、斜体、删除、有序、无序列表、添加时间
      QuillToolbar(
        axis: Axis.horizontal,
          toolbarSize: toolbarIconSize,
          toolbarSectionSpacing: toolbarSectionSpacing,
          toolbarIconAlignment: toolbarIconAlignment,
          toolbarIconCrossAlignment: toolbarIconCrossAlignment,
          customButtons: customButtons,
          locale: locale,
          afterButtonPressed: afterButtonPressed,
          children: [
            QuillFontFamilyButton(
              iconTheme: iconTheme,
              iconSize: toolbarIconSize,
              tooltip: buttonTooltips[ToolbarButtons.fontFamily],
              attribute: Attribute.font,
              controller: controller,
              rawItemsMap: fontFamilies,
              afterButtonPressed: afterButtonPressed,
            ),
            ColorButton(
              icon: Icons.color_lens,
              iconSize: toolbarIconSize,
              tooltip: buttonTooltips[ToolbarButtons.color],
              controller: controller,
              background: false,
              iconTheme: iconTheme,
              afterButtonPressed: afterButtonPressed,
            ),
            ToggleStyleButton(
              attribute: Attribute.bold,
              icon: Icons.format_bold,
              iconSize: toolbarIconSize,
              tooltip: buttonTooltips[ToolbarButtons.bold],
              controller: controller,
              iconTheme: iconTheme,
              afterButtonPressed: afterButtonPressed,
            ),
            ToggleStyleButton(
              attribute: Attribute.underline,
              icon: Icons.format_underline,
              iconSize: toolbarIconSize,
              tooltip: buttonTooltips[ToolbarButtons.underline],
              controller: controller,
              iconTheme: iconTheme,
              afterButtonPressed: afterButtonPressed,
            ),
            ToggleStyleButton(
              attribute: Attribute.italic,
              icon: Icons.format_italic,
              iconSize: toolbarIconSize,
              tooltip: buttonTooltips[ToolbarButtons.italic],
              controller: controller,
              iconTheme: iconTheme,
              afterButtonPressed: afterButtonPressed,
            ),
            ToggleStyleButton(
              attribute: Attribute.strikeThrough,
              icon: Icons.format_strikethrough,
              iconSize: toolbarIconSize,
              tooltip: buttonTooltips[ToolbarButtons.strikeThrough],
              controller: controller,
              iconTheme: iconTheme,
              afterButtonPressed: afterButtonPressed,
            ),
            ToggleStyleButton(
              attribute: Attribute.ol,
              tooltip: buttonTooltips[ToolbarButtons.listNumbers],
              controller: controller,
              icon: Icons.format_list_numbered,
              iconSize: toolbarIconSize,
              iconTheme: iconTheme,
              afterButtonPressed: afterButtonPressed,
            ),
            ToggleStyleButton(
              attribute: Attribute.ul,
              tooltip: buttonTooltips[ToolbarButtons.listBullets],
              controller: controller,
              icon: Icons.format_list_bulleted,
              iconSize: toolbarIconSize,
              iconTheme: iconTheme,
              afterButtonPressed: afterButtonPressed,
            ),
            CustomButton(onPressed: ()=>_insertTimeStamp(widget.controller), icon: Icons.access_time_filled),
      ])
    ;
  }
  void _insertTimeStamp(QuillController controller) {

    String time = DateFormat("yyyy-MM-dd-HH-mm-ss").format(DateTime.now());

    controller.document.insert(controller.selection.extentOffset, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(
      controller.selection.extentOffset,
      TimeStampEmbed(time),
    );

    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(controller.selection.extentOffset, ' ');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(controller.selection.extentOffset, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );
  }
}
