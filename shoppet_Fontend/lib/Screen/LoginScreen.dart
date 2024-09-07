import 'package:flutter/material.dart';

class LoginLayout extends StatefulWidget {
  const LoginLayout({super.key});

  @override
  State<LoginLayout> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // full screen
        children: [
          const Image(
            image: AssetImage("assets/Login_Screen1.png"),
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              // logo and Text
              const Row(
                children: [
                  Padding(padding: EdgeInsets.all(20)),
                  Image(
                    image: AssetImage("assets/logoShopPet_1.png"),
                    width: 130,
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Text(
                    'Shop Pet',
                    style: TextStyle(
                      fontSize: 40,
                      color: Color.fromARGB(255, 235, 145, 11),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 180,
              ),
              //item  input user and password
              Column(
                children: [
                  ///USER AND PASS is haven't  fuction(9/7/24)
                  ///ITEM INPUT USER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Username'),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // use focusedBorder to adjust the color
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.orange,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //ITEM INPUT PASSWORD
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Password'),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          ///  change pass to number("123") =>("***")
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // use focusedBorder to adjust the color
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.orange,
                                  width: 2.0,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    //Open see pass or off
                                    _isObscure = !_isObscure;
                                  });
                                },
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                color: Colors.grey,
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'LOGIN',
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.orange),
                          minimumSize:
                              WidgetStateProperty.all(const Size(200, 50)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text('forgot password'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Sign up'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
