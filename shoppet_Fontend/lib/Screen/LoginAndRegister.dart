import 'package:flutter/material.dart';
import 'package:shoppet_fontend/Screen/LoginScreen.dart';

import 'RegisterScreen.dart';

class Login_Register extends StatelessWidget {
  const Login_Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // fill all image
        children: [
          //background image
          Column(
            children: [
              SizedBox(height: 320,),
              Container(
                  height: MediaQuery.sizeOf(context).height - 320,
                  decoration: const BoxDecoration(
                    color: const Color.fromRGBO(255, 247, 138, 1.0), // Màu nền của Container
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  )
              ),
            ],
          ),

          Column(
            children: [
              const SizedBox(height: 60),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/Image/logoShopPet_1.png"),
                    width: 90,
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Welcome',
                    style: TextStyle(
                        fontSize: 60,
                        color: Color.fromRGBO(232, 124, 0, 1.0),
                        fontFamily: "JustAnotherHand"),
                  )
                ],
              ),

              SizedBox(height: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/Image/undraw_good_doggy_re_eet7.png"),
                    height: MediaQuery.sizeOf(context).height-MediaQuery.sizeOf(context).height*0.7,
                  ),
                ],
              ),
            ],
          ),
          // ảnh
          //login and register
          const SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Padding(padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Registerscreen()),
                        );
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 196, 126, 1.0), // Màu nền của Container
                          borderRadius: BorderRadius.circular(10.0), // Bo tròn góc
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(237, 177, 107, 1.0), // Màu của shadow
                              spreadRadius: 0, // Bán kính lan tỏa của shadow
                              blurRadius: 0, // Độ mờ của shadow
                              offset: Offset(0, 4), // Vị trí của shadow
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'REGISTER',
                            style: TextStyle(color: Color.fromRGBO(90, 53, 11, 1.0)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20, // Khoảng cách giữa các nút
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 1.0), // Màu nền của Container
                          borderRadius: BorderRadius.circular(10.0), // Bo tròn góc
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(148, 40, 0, 1.0), // Màu của shadow
                              spreadRadius: 0, // Bán kính lan tỏa của shadow
                              blurRadius: 0, // Độ mờ của shadow
                              offset: Offset(0, 4), // Vị trí của shadow
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(color: Color.fromRGBO(90, 53, 11, 1.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}
