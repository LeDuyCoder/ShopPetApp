import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppet_fontend/API/Local/config.dart';
import 'package:shoppet_fontend/API/Server/userAPI.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool showPass = false;
  String _passwordError = "";

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      userAPI userService = userAPI();
      HTTPReult checkPass = await userService.checkpass(username: _username.text, password: _password.text);

      setState(() {
        if (checkPass == HTTPReult.ok) {
          _passwordError = "Đăng nhập thành công";
        } else {
          _passwordError = "mật khẩu không đúng 2";
        }
      });
      // Optionally, you can clear the field after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 247, 138, 1.0),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        child: ListView.builder(
          itemCount: 1, // Số lượng mục trong danh sách
          itemBuilder: (context, index) {
            return Column(
              children: [
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
g                  children: [
                    Image.asset("assets/logoShopPet_1.png", width: 100, height: 100),
                    const SizedBox(width: 20),
                    const Text(
                      "Shop Pet",
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: "JustAnotherHand",
                        decoration: TextDecoration.none,
                        color: Color.fromRGBO(232, 124, 0, 1.0)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height - 250,
                  decoration: const BoxDecoration(
                    color: Colors.white, // Màu nền của Container
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30), // Bo góc trên bên trái
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(
                        top: 50,
                        left: 20,
                        right: 20
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
                                const Text("Username", style: TextStyle(fontFamily: "Marvel", fontSize: 15), textAlign: TextAlign.left,),
                                const SizedBox(height: 8), // Khoảng cách giữa các phần tử
                                TextFormField(
                                  controller: _username,
                                  style: const TextStyle(fontSize: 15),
                                  decoration: InputDecoration(
                                    errorText: _passwordError==""?null:_passwordError,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(255, 173, 132, 1.0),
                                        width: 1.0, // Độ dày của viền khi trường không được focus
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(255, 173, 132, 1.0), // Màu sắc của viền khi trường đang được focus
                                        width: 1.0, // Độ dày của viền khi trường được focus
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)), // Bo tròn góc
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(
                                            255, 63, 63, 1.0), // Màu sắc của viền khi trường đang được focus
                                        width: 1.0, // Độ dày của viền khi trường được focus
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)), // Bo tròn góc
                                    ),
                                    focusedErrorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(
                                            255, 63, 63, 1.0), // Màu sắc của viền khi trường đang được focus
                                        width: 1.0, // Độ dày của viền khi trường được focus
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)), // Bo tròn góc
                                    ),
                                  ),
                                  validator: (value) {
                                    if(value!.isEmpty || value == ""){
                                      return "valid value";
                                    }; // Bạn có thể thêm logic kiểm tra ở đây
                                  },
                                ),
                                const SizedBox(height: 10),
                                const Text("Password", style: TextStyle(fontFamily: "Marvel", fontSize: 15), textAlign: TextAlign.left,),
                                const SizedBox(height: 8), // Khoảng cách giữa các phần tử
                                TextFormField(
                                  controller: _password,
                                  obscureText: !showPass,
                                  style: const TextStyle(fontSize: 15),
                                  decoration: InputDecoration(
                                    errorText: _passwordError==""?null:_passwordError,
                                    suffixIcon: IconButton(
                                      icon: Icon(showPass==true?Icons.remove_red_eye:Icons.visibility_off_rounded),
                                      onPressed: (){
                                        setState(() {
                                          showPass = !showPass;
                                        });
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(255, 173, 132, 1.0),
                                        width: 1.0, // Độ dày của viền khi trường không được focus
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(255, 173, 132, 1.0), // Màu sắc của viền khi trường đang được focus
                                        width: 1.0, // Độ dày của viền khi trường được focus
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)), // Bo tròn góc
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(
                                            255, 63, 63, 1.0), // Màu sắc của viền khi trường đang được focus
                                        width: 1.0, // Độ dày của viền khi trường được focus
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)), // Bo tròn góc
                                    ),
                                    focusedErrorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(
                                            255, 63, 63, 1.0), // Màu sắc của viền khi trường đang được focus
                                        width: 1.0, // Độ dày của viền khi trường được focus
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)), // Bo tròn góc
                                    ),
                                  ),
                                  validator: (value) {
                                    if(value!.isEmpty || value == ""){
                                      return "valid value";
                                    }; // Bạn có thể thêm logic kiểm tra ở đây
                                  },
                                ),
                                const SizedBox(height: 40),
                                Center(
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () async {
                                            await _submitForm();
                                          },
                                          child: Container(
                                            width: MediaQuery.sizeOf(context).width - 60,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(255, 196, 126, 1.0), // Màu nền của Container
                                              borderRadius: BorderRadius.circular(10.0), // Bo tròn góc
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromRGBO(237, 177, 107, 1.0), // Màu của shadow
                                                  spreadRadius: 0, // Bán kính lan tỏa của shadow
                                                  blurRadius: 0, // Độ mờ của shadow
                                                  offset: Offset(3, 3), // Vị trí của shadow
                                                ),
                                              ],
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Login',
                                                style: TextStyle(color: Color.fromRGBO(90, 53, 11, 1.0)),
                                              ),
                                            ),
                                          ),
                                      ),
                                      const SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: (){},
                                            child: const Text("Forgot password ?", style: TextStyle(color: Color.fromRGBO(90, 53, 11, 1.0), decoration: TextDecoration.underline),),
                                          ),
                                          GestureDetector(
                                            onTap: (){},
                                            child: const Text("Sign up", style: TextStyle(color: Color.fromRGBO(90, 53, 11, 1.0), decoration: TextDecoration.underline),),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                  ),
                )
              ],
            );
          },
        ),
      )
    );
  }
}
