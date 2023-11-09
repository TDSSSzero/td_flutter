import 'package:flutter/material.dart';

class HeroDetailView extends StatelessWidget {

  const HeroDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body:Center(
        child: Container(
          child: Hero(tag: "fhero", child: FlutterLogo(size: 200)),
        ),
      ),
    );
  }
}