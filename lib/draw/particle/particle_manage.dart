import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:td_flutter/draw/particle/particle.dart';

/// author TDSSS
/// datetime 2023/11/30 10:06
class ParticleManage with ChangeNotifier {
  // 粒子集合
  List<Particle> particles = [];

  Size size;

  ui.Image? image;

  ParticleManage({required this.size,this.image});

  void addParticle(Particle particle) {
    particles.add(particle);
    notifyListeners();
  }

  void tick() {
    particles.forEach(doUpdate);
    notifyListeners();
  }

  void doUpdate(Particle p) {
    // _judgeBallParticleBound(p);
    _judgeRainParticleBound(p);
  }

  void _judgeBallParticleBound(Particle p){
    p.vx += p.ax;
    p.vy += p.ay;
    p.x += p.vx;
    p.y += p.vy;
    //边界情况
    if(p.x > size.width){
      p.x = size.width;
      p.vx = -p.vx;
    }
    if(p.x < 0){
      p.x = 0;
      p.vx = -p.vx;
    }
    if(p.y > size.height){
      p.y = size.height;
      p.vy = -p.vy;
    }
    if(p.y < 0){
      p.y = 0;
      p.vy = -p.vy;
    }
  }

  void _judgeRainParticleBound(Particle p){
    p.vx += p.ax;
    p.vy += p.ay;
    p.x += p.vx;
    p.y += p.vy;
    //边界情况
    if(p.x < 0){
      p.x = size.width;
    }
    if(p.x > size.width){
      p.x = 0;
    }
    if(p.y > size.height){
      p.y = 0;
    }
  }

}