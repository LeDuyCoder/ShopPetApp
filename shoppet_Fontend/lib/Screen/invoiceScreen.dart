import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppet_fontend/API/Server/orderAPI.dart';
import 'package:shoppet_fontend/API/Server/orderItemAPI.dart';
import 'package:shoppet_fontend/Model/apiModel/orderItemModel.dart';
import 'package:shoppet_fontend/Screen/SlashSceen.dart';
import 'package:shoppet_fontend/Screen/orderSuccessScreen.dart';
import 'package:uuid/v4.dart';

import '../Model/apiModel/productModel.dart';
import '../Model/apiModel/userModel.dart';
import '../Model/apiModel/voucherModel.dart';

class invoiceScreen extends StatefulWidget{
  final void Function() togetherNav;

  final Map<String, int> DataAmount;
  final List<Product> listProduct;
  final String totalPrice;
  final double totalPriceDouble;
  final voucher? vouchercoding;

  final void Function() clearDataCartScreen;

  const invoiceScreen({super.key, required this.togetherNav, required this.totalPrice, required this.DataAmount, required this.listProduct, this.vouchercoding, required this.totalPriceDouble, required this.clearDataCartScreen});

  @override
  State<StatefulWidget> createState() => _invoiceScreen();

}

class _invoiceScreen extends State<invoiceScreen>{

  User? user = null;
  bool isLoading = false;


  Future<User> getDataUser() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    User user = User.fromJson(jsonDecode(store.getString("dataUser")!));
    return user;
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en'); // Định dạng sử dụng dấu phẩy
    return formatter.format(amount).replaceAll(',', '.'); // Thay dấu phẩy bằng dấu chấm
  }

  Future<void> createOrder() async {
    orderAPI orderService = orderAPI();
    orderItemAPI orderItemService = orderItemAPI();
    UuidV4 uuidV4 = UuidV4();

    List<Map<String, dynamic>> listOrderItems = [];

    String uuid_order = await orderService.createOrder(userID: user!.userId, voucherID: widget.vouchercoding?.code??null);

    await orderService.updateTotalPrice(orderID: uuid_order, price: widget.totalPriceDouble);


    for(Product product in widget.listProduct){
      listOrderItems.add(
          {
            "orderItemID": uuidV4.generate(),
            "orderID": uuid_order,
            "productID": product.product_id,
            "quantity": widget.DataAmount[product.product_id]!,
            "price": product.price
          },
      );
    }

    await orderItemService.createOrderWithItems(listOrderItems);

    sendMailOrder("duyga544@gmail.com", uuid_order.split("-")[0], widget.totalPriceDouble, user!.name, uuid_order);

    Navigator.push(context, MaterialPageRoute(builder: (context) => orderSuccessScreen(mahoadon: uuid_order.split("-")[0], nameCustomer: user!.name, AddressCustomer: user!.address, invoiceContext: context, clearDataCartScreen: (){
      widget.clearDataCartScreen();
    }, togeterNav: () { widget.togetherNav(); },)));
  }

  String tableProduct() {
    final buffer = StringBuffer();

    for (Product product in widget.listProduct) {
      final amount = widget.DataAmount[product.product_id] ?? 1;
      buffer.writeln("""
      <tr>
        <td>${utf8.decode(product.name.runes.toList())}</td>
        <td>$amount</td>
        <td>${formatCurrency((product.price * amount))} VND</td>
      </tr>
    """);
    }

    return buffer.toString();
  }

  void sendMailOrder(String recipientEmail, String mahoadon, double totalPrice, String nameCustomer, String madonhang) async {
    final smtpServer = gmail('duyga544@gmail.com', 'azlu pvzn wbnq paau');

    // Nội dung HTML cho email
    final htmlContent = '''
  <html>
    <body>
      <h1 style="color: #4CAF50;">Đơn Hàng: #$mahoadon</h1>
      <p>Thông tin đơn hàng của bạn, $nameCustomer:</p>
      <table border="1" cellpadding="10" cellspacing="0" style="border-collapse: collapse;">
        <tr>
          <th>Sản Phẩm</th>
          <th>Số Lượng</th>
          <th>Giá</th>
        </tr>
        ${tableProduct()}
        <tr>
          <th colspan="2" style="text-align: right;">Tổng Giá:</th>
          <th>${formatCurrency(totalPrice)} VND</th>
        </tr>
      </table>
      </br>
      <p1>Thông Tin Khách Hàng</p1>
      <table border="1" cellpadding="10" cellspacing="0" style="border-collapse: collapse;">
        <tr>
          <th>Tên</th>
          <th>Số Điện Thoại</th>
          <th>Địa Chỉ</th>
        </tr>
        <tr>
          <td>${nameCustomer}</td>
          <td>0${user!.phone}</td>
          <td>${user!.address}</td>
        </tr>
      </table>
    </body>
  </html>
  ''';

    final message = Message()
      ..from = const Address('duyga544@gmail.com', 'Shop Pet')
      ..recipients.add(recipientEmail)
      ..subject = 'Thông tin đơn hàng của $nameCustomer'
      ..html = htmlContent;

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: $sendReport');
    } on MailerException catch (e) {
      print('Email not sent. Error: ${e.toString()}');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.togetherNav();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'INVOICE',
          style:
          TextStyle(fontSize: 25, color: Colors.black, fontFamily: 'Itim'),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
                children: [
                  const SizedBox(height: 50),
                  Container(
                    width: MediaQuery.sizeOf(context).width - 50,
                    constraints: const BoxConstraints(minHeight: 500),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 1),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Add this line
                      children: [
                        Container(
                          margin: const EdgeInsets.all(25),
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: const CircleAvatar(
                            backgroundColor: Colors.orange,
                            radius: 30,
                            child: Image(
                              image: AssetImage('assets/Image/logoShopPet 3@2x.png'),
                            ),
                          ),
                        ),
                        const Text(
                          'SHOP PET',
                          style: TextStyle(
                            color: Colors.orange,
                            fontFamily: "JustAnotherHand",
                            fontSize: 50,
                          ),
                        ),
                         Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Payment",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "${widget.totalPrice} VNĐ",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Flexible(
                          child: Column(
                            children: [
                              for(Product product in widget.listProduct)
                                textItem(product.name, '${widget.DataAmount[product.product_id]}', formatCurrency((product.price * widget.DataAmount[product.product_id]!))) // Add more textItem here to expand height automatically
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Divider(
                          color: Color.fromRGBO(219, 219, 219, 1.0),
                          thickness: 2.0,
                          indent: 10.0,
                          endIndent: 10.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Giảm", style: TextStyle(fontSize: 15)),
                              Text("${widget.vouchercoding?.discount??0}%", style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tip", style: TextStyle(fontSize: 15)),
                              Text("0Đ", style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 2.0,
                            dashLength: 5.0,
                            dashGapLength: 2.0,
                            dashColor: Colors.orange,
                            alignment: WrapAlignment.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'THANK YOU !',
                          style: TextStyle(
                            color: Colors.orange,
                            fontFamily: "JustAnotherHand",
                            fontSize: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    height: 70,
                    width: MediaQuery.sizeOf(context).width - 50,
                    decoration:  BoxDecoration(
                        color: Color.fromRGBO(231, 231, 231, 0.3),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: FutureBuilder(future: getDataUser(), builder: (context, data){
                      if(data.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(color: Colors.orangeAccent,),
                        );
                      }

                      user = data.data!;

                      return Row(
                        children: [
                          SizedBox(width: 10,),
                          Image.asset("assets/Image/location.png"),
                          SizedBox(width: 10,),
                          Expanded(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user?.name??"none", style: TextStyle(fontSize: 15)),
                              Text(user?.address??"none", style: TextStyle(fontSize: 15)),
                            ],
                          )),
                          IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.edit_location_alt_outlined))
                        ],
                      );
                    }),
                  ),
                  SizedBox(height: 150,),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, -1),
                    blurRadius: 20
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 180,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Center(
                        child: Text("CANCEL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        if(user!.address == "none"){
                          _showToastError("Địa chỉ chưa được cập nhật");
                        }else{
                          setState(() {
                            isLoading = !isLoading;
                          });
                          createOrder();
                        }
                      },
                      child: Container(
                        width: 180,
                        height: 70,
                        decoration: const BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(221, 126, 78, 1.0),
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  spreadRadius: 0
                              )
                            ]
                        ),
                        child: Center(
                          child: Text("CREATE ORDER", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.brown),),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ),
          ),
          if(isLoading)
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              color: Colors.black.withOpacity(0.2),
              child: Center(
                child: CircularProgressIndicator(color: Colors.orange,),
              ),
            )
        ],
      )
    );
  }

  void _showToastError(String message) {
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

  Widget textItem(String itemName, String amount, String price) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              utf8.decode(itemName.runes.toList()),
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          Expanded(
            child: Text(
              "x$amount",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          Text(
            '${price}Đ',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ],
      ),
    );
  }


}