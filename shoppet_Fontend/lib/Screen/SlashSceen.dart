import 'package:flutter/material.dart';
import 'package:shoppet_fontend/Screen/LoginAndRegister.dart';

class Slashsceen extends StatefulWidget {
  const Slashsceen({super.key});

  @override
  State<Slashsceen> createState() => _SlashsceenState();
}

class _SlashsceenState extends State<Slashsceen> {
  @override
  void initState() {
    super.initState();

    // Sử dụng Future.delayed để chờ 3 giây và chuyển sang màn hình Login_Register
    Future.delayed(const Duration(seconds: 3), () {
      // Chuyển sang màn hình Login_Register sau 3 giây
      Navigator.pushReplacement(
        ///Navigator là lớp quản lý các hoạt động điều hướng (navigation) giữa các màn hình trong Flutter.
        ///pushReplacement: Hàm này thay thế màn hình hiện tại bằng màn hình mới và xóa màn hình hiện tại
        context,
        MaterialPageRoute(builder: (context) => const Login_Register()),
      );
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
