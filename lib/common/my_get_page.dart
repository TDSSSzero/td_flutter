import 'package:flutter/src/animation/animation.dart';
import 'package:flutter/src/animation/curves.dart';
import 'package:flutter/src/painting/alignment.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:get/get_navigation/src/routes/get_transition_mixin.dart';

class MyGetPage extends GetPage{
  MyGetPage({required super.name, required super.page});
}

class MyCustomTransition extends CustomTransition{
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child
      ) {
    print("buildTransitions");
    return SlideLeftTransition().buildTransitions(
        context,
        curve,
        alignment,
        animation,
        secondaryAnimation,
        child);
  }

}