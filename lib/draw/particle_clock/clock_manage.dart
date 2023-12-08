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

  collectParticles(DateTime datetime) {
    // collectDigit(target: 1, offsetRate: 0);
    // collectDigit(target: 9, offsetRate: 1);
    // collectDigit(target: 9, offsetRate: 2);
    // collectDigit(target: 4, offsetRate: 3);
    // collectDigit(target: 0, offsetRate: 0);
    // collectDigit(target: 3, offsetRate: 1);
    // collectDigit(target: 10, offsetRate: 3.2);
    // collectDigit(target: 2, offsetRate: 2.5);
    // collectDigit(target: 8, offsetRate: 3.5);
    // collectDigit(target: 10, offsetRate: 7.25);
    // collectDigit(target: 4, offsetRate: 5);
    // collectDigit(target: 9, offsetRate: 6);
    count = 0;
    if(particles.isNotEmpty){
      particles.clear();
      for (var element in particles) {
        element.active = false;
      }
    }
    collectDigit(target: datetime.hour ~/ 10, offsetRate: 0);
    collectDigit(target: datetime.hour % 10, offsetRate: 1);
    collectDigit(target: 10, offsetRate: 3.2);
    collectDigit(target: datetime.minute ~/ 10, offsetRate: 2.5);
    collectDigit(target: datetime.minute % 10, offsetRate: 3.5);
    collectDigit(target: 10, offsetRate: 7.25);
    collectDigit(target: datetime.second ~/ 10, offsetRate: 5);
    collectDigit(target: datetime.second % 10, offsetRate: 6);
  }

  int count = 0;
  double _radius = 2;

  void collectDigit({int target = 0, double offsetRate = 0}) {
    if (target > 10 && count > numParticles) {
      return;
    }
    double space = _radius * 2;
    double offSetX = (digits[target][0].length * 2 * (_radius + 1) + space) * offsetRate;
    for (int i = 0; i < digits[target].length; i++) {
      for (int j = 0; j < digits[target][j].length; j++) {
        if (digits[target][i][j] == 1) {
          double rX = j * 2 * (_radius + 1) + (_radius + 1); //第(i，j)个点圆心横坐标
          double rY = i * 2 * (_radius + 1) + (_radius + 1); //第(i，j)个点圆心纵坐标
          particles.add(Particle(x: rX + offSetX, y: rY, size: _radius, color: const Color(
              0xFF1B9AF5)));
          count++;
        }
      }
    }
  }

  void tick(DateTime now) {
    collectParticles(now);
    notifyListeners();
  }

  void doUpdate(Particle p, DateTime datetime) {

  }

}