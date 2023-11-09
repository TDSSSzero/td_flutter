import 'package:flutter/material.dart';

MyNotifier myNotifier = MyNotifier();

class MyNotifier with ChangeNotifier {

  double _value = 0.0;
  double get value => _value;

  String get valueStr => '${(value*100).toStringAsFixed(1)}%';

  set value (double value){
    _value = value.clamp(0, 1);
    notifyListeners();
  }
}