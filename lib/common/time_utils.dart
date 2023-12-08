import 'package:intl/intl.dart';

class TimeUtils{
  static const halfSecondDuration = Duration(milliseconds: 500);
}

extension MindsetTime on DateTime{
  String get standard {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(this);
  }
}
