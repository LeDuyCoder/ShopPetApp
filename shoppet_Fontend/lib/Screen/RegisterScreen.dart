import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shoppet_fontend/API/Server/userAPI.dart';
import 'package:shoppet_fontend/Model/apiModel/userModel.dart';
import 'package:shoppet_fontend/Screen/variticationMailScreen.dart';

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
  String _userError = "";
  String _mailError = "";

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // check password = confirmPass ?
      if (_password.text != _confirmpass.text) {
        setState(() {
          _passwordError = "Password euals ConfirmPassword";
        });
      } else {
        userAPI userService = userAPI();
        String hasAccount = await userService.hasUser(username: _username.text);

        if(hasAccount == "true"){
          _userError = "Account exist";
        }else{
          List<User>? listUsers = await userService.getUserByMail(_mail.text);
          print(listUsers?.length);
          if(listUsers != null && listUsers.length < 2){
            final random = Random();
            int randomNumber = 100000 + random.nextInt(900000);
            sendOtpEmail(_mail.text, "$randomNumber");
            Navigator.push(context, MaterialPageRoute(builder: (context) => variticationMailScreen(
                code: "$randomNumber",
                sendMail: (String newCode){
                  sendOtpEmail(_mail.text, newCode);
                },
                dataUser: {
                  "username": _username.text,
                  "password": _password.text,
                  "mail": _mail.text
                },
             )));
          }else{
            _mailError = "mail has reached the maximum number used";
          }
        }

        setState(() {});

      }
    }
  }
  

  /// Kiểm tra chuỗi có phải là email hợp lệ hay không.
   bool isValidEmail(String email) {
    RegExp _emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (email.isEmpty) {
      return false;
    }
    return _emailRegex.hasMatch(email);
  }

  void sendOtpEmail(String recipientEmail, String otpCode) async {
    final smtpServer = gmail('duyga544@gmail.com', 'azlu pvzn wbnq paau');

    final message = Message()
      ..from = const Address('duyga544@gmail.com', 'Shop Pet')
      ..recipients.add(recipientEmail)
      ..subject = 'Your OTP Code'
      ..text = 'Your OTP code is: $otpCode';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: $sendReport');
    } on MailerException catch (e) {
      print('Email not sent. ${e.toString()}');
    }
  }

  // Future<void> dialogOTP(){
  //   return Dialogs.materialDialog(
  //       title: "Vertiy Mail",
  //       customView: Container(
  //         child: Column(
  //           children: [
  //
  //           ],
  //         ),
  //       ),
  //       color: Colors.white,
  //       context: context,
  //       actions: [
  //         IconsOutlineButton(
  //           onPressed: () {},
  //           text: 'Cancel',
  //           iconData: Icons.cancel_outlined,
  //           textStyle: TextStyle(color: Colors.grey),
  //           iconColor: Colors.grey,
  //         ),
  //         IconsButton(
  //           onPressed: () {},
  //           text: 'Delete',
  //           iconData: Icons.delete,
  //           color: Colors.red,
  //           textStyle: TextStyle(color: Colors.white),
  //           iconColor: Colors.white,
  //         ),
  //       ]);
  // }


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
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height - 130,
                  decoration: const BoxDecoration(
                    color: Colors.white, // Màu nền của Container
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                      left: 20,
                      right: 20,
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
                                  errorText: _userError == ""
                                      ? null
                                      : _userError,
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
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  errorText: _mailError == ""
                                      ? null
                                      : _mailError,
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
                                  if (value!.isEmpty || value == "" || !isValidEmail(value)) {
                                    return "valid value";
                                  }

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
