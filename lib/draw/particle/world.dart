import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:td_flutter/draw/particle/particle.dart';
import 'package:td_flutter/draw/particle/particle_manage.dart';
import 'package:td_flutter/draw/particle/world_render.dart';

/// author TDSSS
/// datetime 2023/11/30 10:08
class World extends StatefulWidget {
  const World({super.key});

  @override
  State<World> createState() => _WorldState();
}

class _WorldState extends State<World> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  late final ParticleManage pm;
  final random = Random();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    //初始化30个粒子随机大小和速度
    // initParticleManage();
    //根据计时器随机添加一个粒子
    // generateParticles();
    //画雨滴图片粒子
    _initRainParticles();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    ) ..addListener(pm.tick)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  theWorld(){
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: theWorld,
      child: CustomPaint(
        size: pm.size,
        painter: WorldRender(manage: pm),
      ),
    );
  }

  void initParticleManage(){
    pm = ParticleManage(size: const Size(300, 200));
    for(int i = 0; i < 30; i++){
      pm.particles.add(Particle(
          color: randomRGB(),
          size: 5 + 4 * random.nextDouble(),
          vx: 3 * random.nextDouble() * pow(-1, random.nextInt(20)),
          vy: 3 * random.nextDouble() * pow(-1, random.nextInt(20)),
          ay: 0.1,
          x: 150,
          y: 100));
    }
    // Particle particle = Particle(x: 0, y: 0, vx: 3,vy: 0,ay: 0.05, color: Colors.blue, size: 8);
    // pm.particles = [particle];
  }

  // 获取随机色
  Color randomRGB({int limitR = 0, int limitG = 0, int limitB = 0,}) {
    var r = limitR + random.nextInt(256 - limitR); //红值
    var g = limitG + random.nextInt(256 - limitG); //绿值
    var b = limitB + random.nextInt(256 - limitB); //蓝值
    return Color.fromARGB(255, r, g, b); //生成argb模式的颜色
  }

  void generateParticles(){
    pm = ParticleManage(size: const Size(300, 200));
    // 定义计时器
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // 如果粒子数大于20，停止计时器
      if(pm.particles.length>20){
        timer.cancel();
      }
      // 添加随机粒子
      pm.addParticle(Particle(
          color: randomRGB(),
          size: 5 + 4 * random.nextDouble(),
          vx: 3 * random.nextDouble() * pow(-1, random.nextInt(20)),
          vy: 3 * random.nextDouble() * pow(-1, random.nextInt(20)),
          ay: 0.1,
          x: 150,
          y: 100));
    });
  }

  void _initRainParticles()async{
    pm = ParticleManage(size: const Size(300, 200));
    final data = await rootBundle.load("assets/draw/rain.png");
    pm.image = await decodeImageFromList(data.buffer.asUint8List());
    for(int i = 0; i < 60; i++){
      Particle particle = Particle(
          x: pm.size.width / 60 * i,
          y: 0,
          vx: 1 * random.nextDouble() * pow(-1, random.nextInt(20)),
          vy: 4 * random.nextDouble() + 1);
      pm.particles.add(particle);
    }
  }

}
