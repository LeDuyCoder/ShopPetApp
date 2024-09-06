import 'package:flutter/material.dart';

class LoginRegister extends StatelessWidget {
  const LoginRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // phủ toàn bộ ảnh
        children: [
          // Ảnh nền
          const Image(
            image: AssetImage("assets/Screen_Login_or_Register.png"),
            fit: BoxFit.cover,
          ),

          /// Thiết kế logo và chữ
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
                  Image(
                    image: AssetImage("assets/Wellcome_Back.png"),
                    width: 200,
                    height: 200,
                  ),
                ],
              ),
            ],
          ),

          // Ảnh và nút
          Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Canh giữa các phần tử
            children: [
              const Image(
                image: AssetImage("assets/undraw_good_doggy_re_eet7.png"),
              ),

              const SizedBox(height: 50), // Tạo khoảng cách giữa ảnh và nút

              // Nút Register
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40), // Căn chỉnh chiều rộng của nút
                child: ElevatedButton(
                  onPressed: () {
                    // Thực hiện hành động khi nhấn nút Register
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity,
                        50), // Đảm bảo nút chiếm hết chiều ngang
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.orange, // Màu nền của nút
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),

              const SizedBox(height: 20), // Tạo khoảng cách giữa hai nút

              // Nút Login
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40), // Căn chỉnh chiều rộng của nút
                child: ElevatedButton(
                  onPressed: () {
                    // Thực hiện hành động khi nhấn nút Login
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity,
                        50), // Đảm bảo nút chiếm hết chiều ngang
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.orange, // Màu nền của nút
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),

              const SizedBox(
                  height: 50), // Khoảng cách giữa nút và cạnh dưới màn hình
            ],
          ),
        ],
      ),
    );
  }
}
