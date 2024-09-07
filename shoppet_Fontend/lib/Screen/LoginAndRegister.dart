import 'package:flutter/material.dart';

class Login_Register extends StatelessWidget {
  const Login_Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // full image screen
        children: [
          //background
          const Image(
            image: AssetImage("assets/Screen_Login_or_Register.png"),
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 10,
          ),

          /// logo and text
          const Column(
            children: [
              SizedBox(height: 60),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Image(
                    image: AssetImage("assets/logoShopPet_1.png"),
                    width: 100,
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ' Welcome',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          // ảnh
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("assets/undraw_good_doggy_re_eet7.png"),
              ),
            ],
          ),
          //login and register
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("REGISTER"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                      minimumSize: MaterialStateProperty.all(
                          Size(300, 50)), // Kích thước hình chữ nhật
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20, // Khoảng cách giữa các nút
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("LOGIN"),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          Size(300, 50)), // Kích thước hình chữ nhật
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
