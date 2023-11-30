import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'bg_fx.dart';
import 'clock_bg_particle_painter.dart';
import 'palette.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> with SingleTickerProviderStateMixin {

  late Palette _palette;
  late final BgFx _bgFx;
  late final Ticker _ticker;

  @override
  void initState() {
    _ticker = createTicker(_tick)..start();
    _bgFx = BgFx(
        size: const Size(300, 200),
        time: DateTime.now());
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: const Color(0xff98D9B6).withAlpha(22),
      width: 300,
      height: 200,
      child: _buildBgBlurFx(),
    );
  }

  Widget _buildBgBlurFx() {
    return RepaintBoundary(
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(300, 200),
            painter: ClockBgParticlePainter(fx: _bgFx),
          ),
          BackdropFilter(
          filter: ImageFilter.blur(
          sigmaX: 300 * .05,
          sigmaY: .1,
          ),
          // filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(child: Text(" "))
          )
        ]
      ),
    );
  }

  void _init()async{
    List<Palette> palettes = await _loadPalettes();
    _palette = palettes[0];
    _bgFx.setPalette(_palette);
    setState(() {});
  }

  Future<List<Palette>> _loadPalettes()async{
    String data = await DefaultAssetBundle.of(context).loadString("assets/draw/palettes.json");
    var palettesList = json.decode(data) as List;
    return palettesList.map((p) => Palette.fromJson(p)).toList();
  }

  void _tick(Duration duration){
    if(DateTime.now().second % 5 == 0) _bgFx.tick(duration);
  }

}
