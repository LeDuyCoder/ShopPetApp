import 'package:flutter/material.dart';

class Slashsceen extends StatelessWidget {
  const Slashsceen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            //tạo background
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Splash_Screen.png"),
                  fit: BoxFit.cover),
            ),
            //tạo logo và chữ
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/logoShopPet_1.png"),
                    height: 150,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'SHOP PET',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
