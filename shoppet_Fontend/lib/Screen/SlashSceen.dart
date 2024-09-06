import 'package:flutter/material.dart';

class SladeSceen extends StatelessWidget {
  const SladeSceen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Splash_Screen.png"),
                  fit: BoxFit.cover),
            ),
            child: Container(),
          ),
        ),
      ),
    );
  }
}
