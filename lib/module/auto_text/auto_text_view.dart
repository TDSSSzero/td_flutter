import 'package:auto_size_text/auto_size_text.dart';
// import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auto_size_text_field.dart';
import 'auto_text_logic.dart';

class AutoTextPage extends StatefulWidget {
  AutoTextPage({Key? key}) : super(key: key);

  @override
  State<AutoTextPage> createState() => _AutoTextPageState();
}

class _AutoTextPageState extends State<AutoTextPage> {
  final logic = Get.put(AutoTextLogic());

  final state = Get
      .find<AutoTextLogic>()
      .state;

  final controller = TextEditingController();

  final textData = "".obs;
  int _lineCount = 1;

  @override
  void initState() {
    super.initState();
    controller.addListener(_calculateLineCount);
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 350,
                      color: Colors.black26,
                      child: AutoSizeTextField(
                        controller: controller,
                        onChanged: (s){
                          textData.value = s;
                        },
                        style: const TextStyle(fontSize: 20),
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ),
                    const SizedBox(height: 100,),
                    Container(
                      width: 350,
                      color: Colors.black12,
                      child: Obx(() {
                        return AutoSizeText(
                            textData.value,
                          style: TextStyle(fontSize: 20),
                          maxLines: 5,
                        );
                      }),
                    ),
                    Text("line count : $_lineCount"),
                  ],
                ))));
  }
  void _calculateLineCount() {
    final text = controller.text;
    final lineCount = text.split('\n').length;
    setState(() {
      _lineCount = lineCount;
    });
  }
}
