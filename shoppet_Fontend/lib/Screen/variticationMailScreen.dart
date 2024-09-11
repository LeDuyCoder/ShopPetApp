import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rive/rive.dart' as rive;
import 'package:shoppet_fontend/API/Server/userAPI.dart';
import 'package:shoppet_fontend/Screen/LoginScreen.dart';

class variticationMailScreen extends StatefulWidget{
  final String code;
  final Function(String newcode) sendMail;
  final Map<String, dynamic> dataUser;

  const variticationMailScreen({super.key,
    required this.code,
    required this.sendMail,
    required this.dataUser
  });

  @override
  State<StatefulWidget> createState() => _variticationMailScreen();

}

class _variticationMailScreen extends State<variticationMailScreen>{

  final TextEditingController _pinController = TextEditingController();
  String buttonResend = "RESEND";
  bool isButtonDisabled = false; // Biến để kiểm soát việc bấm nút
  Timer? _timer;
  int _start = 30;
  String codeCheck = "";

  @override
  void initState() {
    super.initState();
    codeCheck = widget.code;
  }

  void startCountdown() {
    setState(() {
      isButtonDisabled = true; // Vô hiệu hóa nút khi bắt đầu đếm ngược
    });

    _start = 30;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
          buttonResend = "${_start}s"; // Cập nhật giá trị
        } else {
          buttonResend = "Resend";
          isButtonDisabled = false; // Hết 30 giây, cho phép bấm lại
          _timer?.cancel(); // Hủy timer
        }
      });
    });
  }

  Future<void> createAccount() async {
    userAPI userService = userAPI();
    userService.createUser(username: widget.dataUser["username"], password: widget.dataUser["password"], mail: widget.dataUser["mail"]);
  }

  // Hàm để kiểm tra giá trị nhập vào
  void _onPinChanged(String value, BuildContext context) {
    if(value.length == 6){
      if(value == codeCheck){
        createAccount();
        dialogSuccess(context);
      }
    }
    // Bạn có thể thực hiện các hành động khác ở đây, chẳng hạn như gửi mã PIN đến máy chủ
  }

  Future<void> dialogSuccess(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true, // Ngăn việc tắt dialog khi bấm ngoài dialog
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Trả về false để ngăn việc đóng dialog khi bấm nút lùi về
            return false;
          },
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              height: 200,
              width: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/ok.png", width: 180),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(232, 124, 0, 1.0),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Đăng Nhập', style: TextStyle(color: Colors.white, fontFamily: "Itim")),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60,),
                Image.asset("assets/OTP.png", width: 200, height: 200,),
                SizedBox(height: 50,),
                const Text("Mail Verification", style: TextStyle(color: Colors.black, decoration: TextDecoration.none, fontFamily: "Itim", fontSize: 25),),
                Column(
                  children: [
                    const Text("Enter the code send to", style: TextStyle(color: Colors.black, decoration: TextDecoration.none, fontFamily: "Mali", fontSize: 12),),
                    Text(widget.dataUser["mail"], style: const TextStyle(color: Colors.black, decoration: TextDecoration.none, fontFamily: "Mali", fontSize: 12, fontWeight: FontWeight.bold),),
                  ],
                ),
                Padding(padding: EdgeInsets.all(10),
                  child: PinCodeTextField(
                    keyboardType: TextInputType.number,
                    appContext: context,
                    length: 6, // Số lượng ô mã PIN
                    obscureText: false, // Hiện thị ký tự
                     // Ký tự thay thế nếu dùng `obscureText`
                    animationType: AnimationType.scale,
                    validator: (v) {
                      if (v!.length < 6) {
                        return null;
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 40,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      activeColor: const Color.fromRGBO(232, 124, 0, 1.0),
                      inactiveColor: Colors.green,
                      selectedColor: const Color.fromRGBO(232, 124, 0, 1.0),
                    ),
                    cursorColor: const Color.fromRGBO(232, 124, 0, 0.5),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    controller: _pinController,
                    onCompleted: (v) {
                      print("Completed: $v");
                      // Bạn có thể thực hiện các hành động khác ở đây khi người dùng hoàn tất nhập mã PIN
                    },
                    onChanged: (value) {
                      _onPinChanged(value, context);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Bạn không nhận được code", style: TextStyle(color: Colors.black, decoration: TextDecoration.none, fontFamily: "Mli", fontSize: 12),),
                    const SizedBox(width: 5,),
                    GestureDetector(
                      onTap: (){
                        var random = Random();
                        int newCode = 100000 + random.nextInt(900000);

                        codeCheck = "$newCode";

                        widget.sendMail('$newCode');
                        startCountdown();
                      },
                      child: Text(buttonResend, style: const TextStyle(color: const Color.fromRGBO(232, 124, 0, 1.0), decoration: TextDecoration.none, fontFamily: "Mali", fontSize: 12),),
                    )
                  ],
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

}