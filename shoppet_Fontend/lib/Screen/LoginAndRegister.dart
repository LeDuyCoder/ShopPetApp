import 'package:flutter/material.dart';

class Login_Register extends StatelessWidget {
  const Login_Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // fill all image
        children: [
          //background image
          const Image(
            image: AssetImage("assets/Screen_Login_or_Register.png"),
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 10,
          ),

          //here design logo
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
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/undraw_good_doggy_re_eet7.png"),
              ),
            ],
          ),
          //login and register
          const SizedBox(
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
                      backgroundColor: WidgetStateProperty.all(Colors.orange),
                      minimumSize: WidgetStateProperty.all(
                          Size(300, 50)), // Kích thước hình chữ nhật
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
                      minimumSize: WidgetStateProperty.all(
                          Size(300, 50)), // Kích thước hình chữ nhật
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
