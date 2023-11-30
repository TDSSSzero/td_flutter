import 'package:flutter/material.dart';
import 'package:td_flutter/draw/particle_clock/particle.dart';
import 'package:td_flutter/draw/particle_clock/res.dart';

/// author TDSSS
/// datetime 2023/11/30 17:46
class ClockManage with ChangeNotifier{

  List<Particle> particles = [];
  int numParticles;
  Size size;
  DateTime dateTime = DateTime.now();

  ClockManage({required this.size, this.numParticles = 500});

  collectParticles() {
    collectDigit(target: 1, index: 0);
    collectDigit(target: 9, index: 1);
    collectDigit(target: 9, index: 2);
    collectDigit(target: 4, index: 3);
  }

  int count = 0;
  double _radius = 3;

  void collectDigit({int target = 0, int index = 0}) {
    if (target > 10) {
      return;
    }
    double offSetX = 0;
    double space = _radius;
    offSetX = (digits[target][0].length * 2 * (_radius + 1) + space * 2) * index;
    for (int i = 0; i < digits[target].length; i++) {
      for (int j = 0; j < digits[target][j].length; j++) {
        if (digits[target][i][j] == 1) {
          double rX = j * 2 * (_radius + 1) + (_radius + 1); //第(i，j)个点圆心横坐标
          double rY = i * 2 * (_radius + 1) + (_radius + 1); //第(i，j)个点圆心纵坐标
          particles.add(Particle(x: rX + offSetX, y: rY, size: _radius, color: Colors.green.shade200, active: true));
          count++;
        }
      }
    }
  }

  void tick(DateTime now) {
    collectParticles();
    notifyListeners();
  }

  void doUpdate(Particle p, DateTime datetime) {

  }

}