import 'package:flutter/material.dart';

class DebugDialog extends StatelessWidget {

  const DebugDialog({super.key,required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      alignment: Alignment.center,
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Colors.white),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: children
      ),
    );
  }
}