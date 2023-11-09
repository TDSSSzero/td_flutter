import 'package:flutter/material.dart';
import 'package:td_flutter/module/class_test/change_notify_test/my_notifier.dart';

class DetailProgressView extends StatefulWidget {
  const DetailProgressView({super.key});

  @override
  State<DetailProgressView> createState() => _DetailProgressViewState();
}

class _DetailProgressViewState extends State<DetailProgressView> {

  @override
  void initState() {
    super.initState();
    myNotifier.addListener(_update);
  }

  @override
  void dispose() {
    myNotifier.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children:[
        SizedBox(
          width: 200,
          height: 50,
          child: LinearProgressIndicator(
            value: myNotifier.value,
            backgroundColor: Colors.grey,
          ),
        ),
        Text(myNotifier.valueStr,style: TextStyle(color: Colors.white),)
      ],
    );
  }

  void _update(){
    setState(() {
    });
  }
}
