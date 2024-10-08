import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppet_fontend/API/Server/userAPI.dart';

import 'package:http/http.dart' as http;
import 'package:shoppet_fontend/Screen/LoginAndRegister.dart';

import '../Model/apiModel/userModel.dart';

class profileScreen extends StatefulWidget{
  bool isLoad = false;
  final void Function() together_Nav;
  final BuildContext contextHomeScreen;

  profileScreen({super.key, required this.together_Nav, required this.contextHomeScreen});

  @override
  State<StatefulWidget> createState() => _profileScreen();
}

class _profileScreen extends State<profileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  TextEditingController idControler = TextEditingController();
  TextEditingController fullnameControler = TextEditingController();
  TextEditingController mailControler = TextEditingController();
  TextEditingController addressControler = TextEditingController();
  TextEditingController phoneControler = TextEditingController();

  TextEditingController cardNumber = TextEditingController();
  TextEditingController nameOnCard = TextEditingController();
  TextEditingController securityCode = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  
  String image = '';

  File? _image;


  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        setState(() {
          _image = file;
        });
        List<int> imageBytes = await file.readAsBytes();
        String base64String = base64Encode(imageBytes);
        setState(() {
          image = base64String;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), // Tùy chọn giao diện
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        // Chỉ hiển thị tháng và năm
        _dateController.text = DateFormat('MM/yy').format(pickedDate);
      });
    }
  }
  
  @override
  void initState() {
  super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Uint8List base64ToImage(String base64String) {
    return const Base64Decoder().convert(base64String);
  }

  Future<User> getDataUse() async {
    SharedPreferences storeData = await SharedPreferences.getInstance();
    String? dataUser = storeData.getString("dataUser");
    return User.fromJson(jsonDecode(dataUser!));
  }

  Future<void> updateData() async {
    SharedPreferences storeData = await SharedPreferences.getInstance();
    String? dataUser = storeData.getString("dataUser");
    User user = User.fromJson(jsonDecode(dataUser!));

    String newName = "";
    String newAddress = "";
    int newPhone = 0;

    if(user.name != fullnameControler.text){
      newName = fullnameControler.text;
    }
    if(user.address != addressControler.text){
      newAddress = addressControler.text;
    }
    if(user.phone != int.parse(phoneControler.text)){
      newPhone = int.parse(phoneControler.text);
    }

    userAPI userService = userAPI();
    if(newPhone != 0 || newName != "" || newAddress != "" || _image != null) {
      await userService.updateUser(
          user.userId, name: newName == "" ? "none" : newName,
          phone: newPhone == 0 ? 0 : newPhone,
          address: newAddress == "" ? "none" : newAddress,
          image: _image);

      User newDataUser = User(
          userId: user.userId,
          username: user.name,
          password: user.password,
          mail: user.mail,
          name: newName == "" ? user.name : newName,
          phone: newPhone == 0 ? user.phone : newPhone,
          createdAt: user.createdAt,
          role: user.role,
          image: image,
          address: newAddress == "" ? user.address : newAddress);

      storeData.remove("dataUser");
      storeData.setString("dataUser", jsonEncode(newDataUser.toJson()));
    }
    setState(() {
      widget.isLoad = false;
    });
  }

  Future<Map<String, dynamic>?> getDataBank() async {
    SharedPreferences storeData = await SharedPreferences.getInstance();
    User usser = User.fromJson( jsonDecode(storeData.getString("dataUser")!));
    String userID = usser.userId;
    if(storeData.containsKey("bank.$userID")){
      String? data = storeData.getString("bank.$userID");
      Map<String, dynamic> dataBank = jsonDecode(data!);
      return dataBank;
    }else{
      return null;
    }
  }

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

  Future<void> updateBank() async {
    SharedPreferences storeData = await SharedPreferences.getInstance();
    User usser = User.fromJson( jsonDecode(storeData.getString("dataUser")!));
    String userID = usser.userId;
    if(storeData.containsKey("bank.$userID")){
      Map<String, dynamic> dataBankStore = jsonDecode(storeData.getString("bank.$userID")!);
      String newCardNumber = "";
      String newNameonCard = "";
      String newexpirity = "";
      String newSecurityCode = "";
      String newScheme = "";

      if(dataBankStore["cardNumber"] != cardNumber.text){
        final response = await http.get(Uri.parse('https://lookup.binlist.net/${cardNumber.text.substring(0, 7)}'));
        if(response.statusCode == 200){
          Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
          if(jsonResponse.containsKey("scheme")){
            if(jsonResponse["scheme"] == "visa" || jsonResponse["scheme"] == "masterCard" || jsonResponse["scheme"] == "jcb") {
              newCardNumber = cardNumber.text;
              newScheme = jsonResponse["scheme"];
            }else{
              _showToast("valid card");
            }
          }
        }
      }
      if(dataBankStore["nameonCard"] != nameOnCard.text){
        newNameonCard = nameOnCard.text;
      }
      if(dataBankStore["expiryDate"] != _dateController.text){
        newexpirity = _dateController.text;
      }
      if(dataBankStore[securityCode] != securityCode.text){
        newSecurityCode = securityCode.text;
      }

      Map<String, dynamic> dataCardStore = {
        "scheme": newScheme==""?dataBankStore["scheme"]:newScheme,
        "cardNumber": newCardNumber==""?dataBankStore["cardNumber"]:newCardNumber,
        "nameonCard": newNameonCard==""?dataBankStore["nameonCard"]:newNameonCard,
        "expiryDate": newexpirity==""?dataBankStore["expiryDate"]:newexpirity,
        "securityCode": newSecurityCode==""?dataBankStore["securityCode"]:newSecurityCode
      };
      
      await storeData.setString("bank.$userID", jsonEncode(dataCardStore));
      setState(() {
        widget.isLoad = false;
      });
    }else{
      String cardNumber6NumStart = cardNumber.text.substring(0, 7);
      final response = await http.get(Uri.parse('https://lookup.binlist.net/$cardNumber6NumStart'));
      if(response.statusCode == 200){
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        if(jsonResponse.containsKey("scheme")){
          if(jsonResponse["scheme"] == "visa" || jsonResponse["scheme"] == "masterCard" || jsonResponse["scheme"] == "jcb") {
            Map<String, dynamic> dataCardStore = {
              "scheme": jsonResponse["scheme"],
              "cardNumber": cardNumber.text,
              "nameonCard": fullnameControler.text,
              "expiryDate": _dateController.text,
              "securityCode": securityCode.text
            };

            await storeData.setString("bank.$userID", jsonEncode(dataCardStore));

            widget.isLoad = false;
          }else{
            _showToast("valid card");
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              const SizedBox(height: 50,),
              Center(
                child: Container(
                  width: 250, // Chiều rộng của TabBar
                  height: 50, // Chiều cao của TabBar
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200, // Màu nền
                    borderRadius: BorderRadius.circular(25), // Bo góc
                  ),
                  child: TabBar(
                    splashFactory: NoSplash.splashFactory,
                    splashBorderRadius: const BorderRadius.all(Radius.circular(20)),
                    isScrollable: false,
                    dividerColor: Colors.white,
                    controller: _tabController,
                    labelColor: Colors.white, // Màu chữ của tab được chọn
                    unselectedLabelColor: Colors.black,
                    indicator: BoxDecoration(
                      color: const Color.fromRGBO(232, 124, 0, 1.0), // Màu của tab được chọn
                      borderRadius: BorderRadius.circular(25), // Bo góc cho tab được chọn
                    ),
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: -40),
                    tabs: const [
                      Tab(text: 'Profile'),
                      Tab(text: 'Card Bank'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    FutureBuilder(future: getDataUse(), builder: (context, data){
                      if(data.connectionState == ConnectionState.waiting){
                        return Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            child: const CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          ),
                        );
                      }

                      if(data.hasData){

                        idControler.text = data.data!.userId;
                        fullnameControler.text = data.data!.name;
                        mailControler.text = data.data!.mail;
                        addressControler.text = data.data!.address;
                        phoneControler.text = '0${data.data!.phone}';

                        if(image == "") {
                          image = data.data!.image;
                        }

                        return ProfileView();
                      }else{
                        return Image.asset("assets/Image/404.png");
                      }

                    }),
                    CardBank(),
                  ],
                ),
              ),
            ],
          ),
        ),
        widget.isLoad ? Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: const Color.fromRGBO(0, 0, 0, 0.2),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          ),
        ):const Center()
      ],
    );
  }

  Widget ProfileView(){
    return Container(
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () async {
                  await _pickImage();
                },
                child: Stack(
                  children: [
                    Center(
                      child: ClipOval(
                        child: image == "" ? Image.network(
                          'https://wallpapercave.com/wp/wp7171970.jpg', // Đường dẫn ảnh
                          width: 100, // Chiều rộng của hình tròn
                          height: 100, // Chiều cao của hình tròn
                          fit: BoxFit.cover, // Điều chỉnh kích thước ảnh phù hợp
                        ): Image.memory(
                          base64ToImage(image), // Đường dẫn ảnh
                          width: 100, // Chiều rộng của hình tròn
                          height: 100, // Chiều cao của hình tròn
                          fit: BoxFit.cover, // Điều chỉnh kích thước ảnh phù hợp
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: const Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(Icons.edit_note_outlined),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("ID", style: TextStyle(color: Colors.black, fontFamily: "Mali", fontWeight: FontWeight.bold),),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 20, // Chiều cao tối thiểu
                        maxHeight: 40, // Chiều cao tối đa
                      ),
                      child: TextField(
                        controller: idControler,
                        style: TextStyle(color: Colors.grey),
                        enabled: false,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.0,
                                  color: Color.fromRGBO(212, 212, 212, 1.0)
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,  // Padding theo chiều dọc
                              horizontal: 15, // Padding theo chiều ngang
                            ),

                        )
                        ,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text("Mail", style: TextStyle(color: Colors.black, fontFamily: "Mali", fontWeight: FontWeight.bold),),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 20, // Chiều cao tối thiểu
                        maxHeight: 40, // Chiều cao tối đa
                      ),
                      child: TextField(
                        enabled: false,
                        controller: mailControler,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1.0,
                                color: Color.fromRGBO(212, 212, 212, 1.0)
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,  // Padding theo chiều dọc
                            horizontal: 15, // Padding theo chiều ngang
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text("Họ và Tên", style: TextStyle(color: Colors.black, fontFamily: "Mali", fontWeight: FontWeight.bold),),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 20, // Chiều cao tối thiểu
                        maxHeight: 40, // Chiều cao tối đa
                      ),
                      child: TextField(
                        controller: fullnameControler,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.edit_note, color: Colors.grey,),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.0,
                                  color: Color.fromRGBO(212, 212, 212, 1.0)
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,  // Padding theo chiều dọc
                              horizontal: 15, // Padding theo chiều ngang
                            ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text("Địa Chỉ", style: TextStyle(color: Colors.black, fontFamily: "Mali", fontWeight: FontWeight.bold),),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 20, // Chiều cao tối thiểu
                        maxHeight: 40, // Chiều cao tối đa
                      ),
                      child: TextField(
                        controller: addressControler,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.edit_note, color: Colors.grey,),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.0,
                                  color: Color.fromRGBO(212, 212, 212, 1.0)
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,  // Padding theo chiều dọc
                            horizontal: 15, // Padding theo chiều ngang
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text("Số Điện Thoại", style: TextStyle(color: Colors.black, fontFamily: "Mali", fontWeight: FontWeight.bold),),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 20, // Chiều cao tối thiểu
                        maxHeight: 40, // Chiều cao tối đa
                      ),
                      child: TextField(
                        controller: phoneControler,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.edit_note, color: Colors.grey,),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.0,
                                  color: Color.fromRGBO(212, 212, 212, 1.0)
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,  // Padding theo chiều dọc
                            horizontal: 15, // Padding theo chiều ngang
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.isLoad = true;
                              });
                              updateData();
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width - MediaQuery.sizeOf(context).width * 0.6,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 196, 126, 1.0), // Màu nền của Container
                                borderRadius: BorderRadius.circular(60.0), // Bo tròn góc
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
                                  'Cập Nhật',
                                  style: TextStyle(color: Color.fromRGBO(90, 53, 11, 1.0), fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Itim"),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              SharedPreferences storeDate = await SharedPreferences.getInstance();
                              storeDate.remove("dataUser");

                              Navigator.pushReplacement(widget.contextHomeScreen, MaterialPageRoute(builder: (context) => Login_Register()));

                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width - MediaQuery.sizeOf(context).width * 0.6,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 63, 63, 1.0), // Màu nền của Container
                                borderRadius: BorderRadius.circular(60.0), // Bo tròn góc
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(205, 205, 205, 1.0), // Màu của shadow
                                    spreadRadius: 0, // Bán kính lan tỏa của shadow
                                    blurRadius: 0, // Độ mờ của shadow
                                    offset: Offset(0, 4), // Vị trí của shadow
                                  ),
                                ],
                              ),
                              child: const Center(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.logout, color: Colors.white,),
                                      SizedBox(width: 5,),
                                      Text(
                                        'Log Out',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Itim"),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget CardBank(){
    return FutureBuilder(future: getDataBank(), builder: (context, data){
      if(data.connectionState == ConnectionState.waiting){
        return Container(
          height: 50,
          width: 50,
          child: const CircularProgressIndicator(color: Colors.orange,),
        );
      }

      if(data.hasError){
        return Image.asset("assets/Image/404.png");
      }

      String scheme = "visa";
      String endNnumber = "";
      if(data.hasData){
        scheme = data.data!["scheme"];
        cardNumber.text = data.data!["cardNumber"];
        nameOnCard.text = data.data!["nameonCard"];
        _dateController.text = data.data!["expiryDate"];
        securityCode.text = data.data!["securityCode"];
        endNnumber = cardNumber.text.substring(12);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          Center(
            child: data.hasData ? Container(
                height: 160,
                width: MediaQuery.sizeOf(context).width - 20,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 25,
                        width: 50,
                        child: Image.asset("assets/Image/$scheme.png", width:80,),
                      ),
                      const SizedBox(height: 10,),
                      const Text("Card Number", style: TextStyle(fontFamily: "Mina", color: Colors.white, fontWeight:  FontWeight.bold, fontSize: 20),),
                      Text("*** *** *** $endNnumber", style: const TextStyle(fontFamily: "Mina", color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),

                      Row(
                        children: [
                          Expanded(
                            child: Text(nameOnCard.text, style: const TextStyle(fontFamily: "Mina", color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              const Text("VALID THROUGH", style: TextStyle(fontFamily: "Mina", color: Colors.white, fontWeight:  FontWeight.bold, fontSize: 10),),
                              Text(_dateController.text, style: const TextStyle(fontFamily: "Mina", color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                )
            ) : DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  padding: EdgeInsets.all(6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child:Container(
                    height: 160,
                    width: MediaQuery.sizeOf(context).width - 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        style: BorderStyle.none
                      )
                    ),
                    child: const Center(
                      child: Icon(Icons.add_card, size: 100, color: Colors.grey,),
                    ),
                  ),
                )
            )
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Card Number", style: TextStyle(color: Colors.black, fontFamily: "Mali", fontWeight: FontWeight.bold),),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 20, // Chiều cao tối thiểu
                        maxHeight: 40, // Chiều cao tối đa
                      ),
                      child: TextField(
                        controller: cardNumber,
                        style: TextStyle(color: Colors.grey),
                        enabled: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1.0,
                                color: Color.fromRGBO(212, 212, 212, 1.0)
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,  // Padding theo chiều dọc
                            horizontal: 15, // Padding theo chiều ngang
                          ),

                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text("Name on card", style: TextStyle(color: Colors.black, fontFamily: "Mali", fontWeight: FontWeight.bold),),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 20, // Chiều cao tối thiểu
                        maxHeight: 40, // Chiều cao tối đa
                      ),
                      child: TextField(
                        controller: nameOnCard,
                        style: const TextStyle(color: Colors.grey),
                        enabled: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1.0,
                                color: Color.fromRGBO(212, 212, 212, 1.0)
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,  // Padding theo chiều dọc
                            horizontal: 15, // Padding theo chiều ngang
                          ),

                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Expiry Date", style: TextStyle(color: Colors.black, fontFamily: "Mali", fontWeight: FontWeight.bold),),
                              ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 20,
                                    maxHeight: 40,
                                  ),
                                  child: TextField(
                                    controller: _dateController,
                                    keyboardType: TextInputType.datetime,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                                      LengthLimitingTextInputFormatter(5), // Giới hạn 5 ký tự cho mm/yy
                                      _DateInputFormatter(), // Tự động định dạng thành mm/yy
                                    ],
                                    style: const TextStyle(color: Colors.grey),
                                    enabled: true,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          _selectDate(context); // Hiển thị DatePicker khi nhấn vào icon
                                        },
                                        icon: Icon(Icons.calendar_today_rounded, color: Colors.grey, size: 20),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: Color.fromRGBO(212, 212, 212, 1.0)
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 10), // Thêm khoảng cách giữa 2 cột
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Security Code", style: TextStyle(color: Colors.black, fontFamily: "Mali", fontWeight: FontWeight.bold),),
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minHeight: 20,
                                  maxHeight: 40,
                                ),
                                child: TextField(
                                  controller: securityCode,
                                  style: const TextStyle(color: Colors.grey),
                                  enabled: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1.0,
                                          color: Color.fromRGBO(212, 212, 212, 1.0)
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 15,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.isLoad = true;
                  updateBank();
                });
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width - 50,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 196, 126, 1.0), // Màu nền của Container
                  borderRadius: BorderRadius.circular(60.0), // Bo tròn góc
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
                    'Cập Nhật',
                    style: TextStyle(color: Color.fromRGBO(90, 53, 11, 1.0)),
                  ),
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Tự động thêm dấu '/' sau khi nhập tháng
    if (newValue.text.length == 2 && !newValue.text.contains('/')) {
      return TextEditingValue(
        text: '${newValue.text}/',
        selection: TextSelection.collapsed(offset: newValue.text.length + 1),
      );
    }
    return newValue;
  }
}

