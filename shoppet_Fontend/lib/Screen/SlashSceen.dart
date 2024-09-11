import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppet_fontend/Screen/LoginAndRegister.dart';
import 'package:shoppet_fontend/Screen/homeScreen.dart';

class Slashsceen extends StatefulWidget {
  const Slashsceen({super.key});

  @override
  State<Slashsceen> createState() => _SlashsceenState();
}

class _SlashsceenState extends State<Slashsceen> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: -100, end: 20).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object's value.
        });
      });
    controller.forward();

    // Sử dụng Future.delayed để chờ 3 giây và chuyển sang màn hình Login_Register
    Future.delayed(const Duration(seconds: 10), () async {

      SharedPreferences storeData = await SharedPreferences.getInstance();
      if(storeData.containsKey("dataUser")) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => homeScreen()),
        );
      }else {
        // Chuyển sang màn hình Login_Register sau 3 giây
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login_Register()),
        );
      }
    });
  }

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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, animation.value), // Animation dịch chuyển hình ảnh
                        child: child,
                      );
                    },
                    child: Image.asset(
                      "assets/logoShopPet_1.png",
                      height: 150,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'SHOP PET',
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontFamily: "JustAnotherHand"
                    ),
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
