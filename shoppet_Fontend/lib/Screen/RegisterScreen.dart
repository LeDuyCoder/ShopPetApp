import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppet_fontend/API/Local/config.dart';
import 'package:shoppet_fontend/API/Server/userAPI.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _mail = TextEditingController();
  final TextEditingController _confirmpass = TextEditingController();
  bool showPass = false;
  bool showconfirmpass = false;
  String _passwordError = "";
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // check password = confirmPass ?
      if (_password.text != _confirmpass.text) {
        setState(() {
          _passwordError = "Password euals ConfirmPassword";
        });
      } else {
        userAPI userService = userAPI();
        HTTPReult chesspass = await userService.checkpass(
            username: _username.text, password: _password.text);
        setState(() {
          if (chesspass == HTTPReult.ok) {
            _passwordError = "Success Register ";
          } else {
            _passwordError = "Fail Register";
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 247, 138, 1.0),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontFamily: "JustAnotherHand",
                        fontSize: 70,
                        color: Color.fromRGBO(232, 124, 0, 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height - 150,
                  decoration: const BoxDecoration(
                    color: Colors.white, // Màu nền của Container
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                      left: 50,
                      right: 50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // USERNAME
                              const Text(
                                "Username",
                                style: TextStyle(
                                    fontFamily: "Marvel", fontSize: 15),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _username,
                                style: const TextStyle(fontSize: 15),
                                decoration: InputDecoration(
                                  errorText: _passwordError == ""
                                      ? null
                                      : _passwordError,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 12.0),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 173, 132, 1.0),
                                      width:
                                          1.0, // Độ dày của viền khi trường không được focus
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 173, 132,
                                          1.0), // Màu sắc của viền khi trường đang được focus
                                      width:
                                          1.0, // Độ dày của viền khi trường được focus
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)), // Bo tròn góc
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 63, 63,
                                          1.0), // Màu sắc của viền khi trường đang được focus
                                      width:
                                          1.0, // Độ dày của viền khi trường được focus
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)), // Bo tròn góc
                                  ),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 63, 63,
                                          1.0), // Màu sắc của viền khi trường đang được focus
                                      width:
                                          1.0, // Độ dày của viền khi trường được focus
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)), // Bo tròn góc
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || value == "") {
                                    return "valid value";
                                  }
                                  ; // Bạn có thể thêm logic kiểm tra ở đây
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Password",
                                style: TextStyle(
                                    fontFamily: "Marvel", fontSize: 15),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                  height: 8), // Khoảng cách giữa các phần tử
                              TextFormField(
                                controller: _password,
                                obscureText: !showPass,
                                style: const TextStyle(fontSize: 15),
                                decoration: InputDecoration(
                                  errorText: _passwordError == ""
                                      ? null
                                      : _passwordError,
                                  suffixIcon: IconButton(
                                    icon: Icon(showPass == true
                                        ? Icons.remove_red_eye
                                        : Icons.visibility_off_rounded),
                                    onPressed: () {
                                      setState(() {
                                        showPass = !showPass;
                                      });
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 12.0),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 173, 132, 1.0),
                                      width:
                                          1.0, // Độ dày của viền khi trường không được focus
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 173, 132,
                                          1.0), // Màu sắc của viền khi trường đang được focus
                                      width:
                                          1.0, // Độ dày của viền khi trường được focus
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)), // Bo tròn góc
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 63, 63,
                                          1.0), // Màu sắc của viền khi trường đang được focus
                                      width:
                                          1.0, // Độ dày của viền khi trường được focus
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)), // Bo tròn góc
                                  ),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 63, 63,
                                          1.0), // Màu sắc của viền khi trường đang được focus
                                      width:
                                          1.0, // Độ dày của viền khi trường được focus
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)), // Bo tròn góc
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || value == "") {
                                    return "valid value";
                                  } else if (value.length < 6) {
                                    return "mật khẩu ít nhất có 6 kí tư";
                                  }
                                  return null;
                                  ; // Bạn có thể thêm logic kiểm tra ở đây
                                },
                              ),
                              // ConfirmPass
                              const Text(
                                "Confirm Password",
                                style: TextStyle(
                                    fontFamily: "Marvel", fontSize: 15),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                  height: 8), // Khoảng cách giữa các phần tử
                              TextFormField(
                                controller: _confirmpass,
                                obscureText: !showconfirmpass,
                                style: const TextStyle(fontSize: 15),
                                decoration: InputDecoration(
                                  errorText: _passwordError == ""
                                      ? null
                                      : _passwordError,
                                  suffixIcon: IconButton(
                                    icon: Icon(showconfirmpass == true
                                        ? Icons.remove_red_eye
                                        : Icons.visibility_off_rounded),
                                    onPressed: () {
                                      setState(() {
                                        showconfirmpass = !showconfirmpass;
                                      });
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 12.0),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 173, 132, 1.0),
                                      width:
                                          1.0, // Độ dày của viền khi trường không được focus
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 173, 132,
                                          1.0), // Màu sắc của viền khi trường đang được focus
                                      width:
                                          1.0, // Độ dày của viền khi trường được focus
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)), // Bo tròn góc
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 63, 63,
                                          1.0), // Màu sắc của viền khi trường đang được focus
                                      width:
                                          1.0, // Độ dày của viền khi trường được focus
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)), // Bo tròn góc
                                  ),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 63, 63,
                                          1.0), // Màu sắc của viền khi trường đang được focus
                                      width:
                                          1.0, // Độ dày của viền khi trường được focus
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)), // Bo tròn góc
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || value == "") {
                                    return "please confirm password";
                                  } else if (value != _password.text) {
                                    return "mật khẩu không khớp";
                                  }
                                  return null; // Bạn có thể thêm logic kiểm tra ở đây
                                },
                              ),
                              //mail
                              const Text(
                                "Mail",
                                style: TextStyle(
                                    fontFamily: "Marvel", fontSize: 15),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _mail,
                                style: const TextStyle(fontSize: 15),
                                decoration: InputDecoration(
                                  errorText: _passwordError == ""
                                      ? null
                                      : _passwordError,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 12.0),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 173, 132, 1.0),
                                      width:
                                          1.0, // Độ dày của viền khi trường không được focus
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 173, 132,
                                          1.0), // Màu sắc của viền khi trường đang được focus
                                      width:
                                          1.0, // Độ dày của viền khi trường được focus
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)), // Bo tròn góc
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 63, 63,
                                          1.0), // Màu sắc của viền khi trường đang được focus
                                      width:
                                          1.0, // Độ dày của viền khi trường được focus
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)), // Bo tròn góc
                                  ),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 63, 63,
                                          1.0), // Màu sắc của viền khi trường đang được focus
                                      width:
                                          1.0, // Độ dày của viền khi trường được focus
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)), // Bo tròn góc
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || value == "") {
                                    return "valid value";
                                  }
                                  ; // Bạn có thể thêm logic kiểm tra ở đây
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    //Register
                                    GestureDetector(
                                      onTap: () async {
                                        await _submitForm();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width -
                                                60,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              255,
                                              196,
                                              126,
                                              1.0), // Màu nền của Container
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Bo tròn góc
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color.fromRGBO(237, 177,
                                                  107, 1.0), // Màu của shadow
                                              spreadRadius:
                                                  0, // Bán kính lan tỏa của shadow
                                              blurRadius: 0, // Độ mờ của shadow
                                              offset: Offset(
                                                  3, 3), // Vị trí của shadow
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Register',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    90, 53, 11, 1.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    // have account
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: const Text(
                                            "Have Account ?",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    90, 53, 11, 1.0),
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
