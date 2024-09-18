import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  bool checkInternet = false;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel(); // Hủy đăng ký stream khi không cần thiết nữa
    super.dispose();
  }

  Future<void> _startCheckingNetwork() async {
    _subscription = _connectivity.onConnectivityChanged.listen((result) async {
      // Chạy một luồng khác để kiểm tra
      Timer.periodic(const Duration(seconds: 2), (timer) async {
        if(checkInternet == false) {
          if (result[0] == ConnectivityResult.mobile) {
            checkInternet = true;
          }
          else if (result[0] == ConnectivityResult.wifi) {
            checkInternet = true;
          }
          else {
            _showToast("Không có kết nối mạng");
          }
        }
      });

      await Future.delayed(const Duration(seconds: 1)); // Giả lập luồng background

      // Gửi tín hiệu về main thread để hiển thị Toast

    });
  }

  // Hàm hiển thị thông báo Toast
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    super.initState();

    _startCheckingNetwork();

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
      Timer? _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        if (checkInternet) {
          SharedPreferences storeData = await SharedPreferences.getInstance();

          // Kiểm tra widget có còn mounted không trước khi chuyển trang
          if (!mounted) return;

          if (storeData.containsKey("dataUser")) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => homeScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login_Register()),
            );
          }
        }
      });

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
                  image: AssetImage("assets/Image/Splash_Screen.png"),
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
                      "assets/Image/logoShopPet_1.png",
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
