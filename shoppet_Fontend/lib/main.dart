import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shoppet_fontend/API/Local/config.dart';
import 'package:shoppet_fontend/API/Server/adminlogAPI.dart';
import 'package:shoppet_fontend/API/Server/cartAPI.dart';
import 'package:shoppet_fontend/API/Server/cartItemAPI.dart';
import 'package:shoppet_fontend/API/Server/categoryAPI.dart';
import 'package:shoppet_fontend/API/Server/orderAPI.dart';
import 'package:shoppet_fontend/API/Server/orderItemAPI.dart';
import 'package:shoppet_fontend/API/Server/paymentAPI.dart';
import 'package:shoppet_fontend/API/Server/productAPI.dart';
import 'package:shoppet_fontend/API/Server/userAPI.dart';
import 'package:shoppet_fontend/API/Server/voucherAPI.dart';
import 'package:shoppet_fontend/API/Server/voucherUseAPI.dart';
import 'package:shoppet_fontend/Model/apiModel/adminlogModel.dart';
import 'package:shoppet_fontend/Model/apiModel/cartItemModel.dart';
import 'package:shoppet_fontend/Model/apiModel/categoryModel.dart';
import 'package:shoppet_fontend/Model/apiModel/orderItemModel.dart';
import 'package:shoppet_fontend/Model/apiModel/payment.dart';
import 'package:shoppet_fontend/Model/apiModel/productModel.dart';
import 'package:shoppet_fontend/Model/apiModel/userModel.dart';
import 'package:shoppet_fontend/Model/apiModel/voucherModel.dart';
import 'package:shoppet_fontend/Model/apiModel/voucherUseModel.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

import 'Model/apiModel/cartModel.dart';
import 'Model/apiModel/orderModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String text = "";


  void _incrementCounter() async {
    userAPI? userService = userAPI();
    productAPI? productService = productAPI();
    adminlogAPI? adminlogService = adminlogAPI();
    categoryAPI? categotyService = categoryAPI();
    orderAPI? orderService = orderAPI();
    orderItemAPI? orderItemService = orderItemAPI();
    cartAPI? cartService = cartAPI();
    cartItemAPI? cartItemService = cartItemAPI();
    paymentAPI? paymentService = paymentAPI();
    voucherAPI? voucherService = voucherAPI();
    voucherUseAPI? voucheruseService = voucherUseAPI();
    
    setState(() {
      text = "demo";
    });



    //List<Category>? listCategory = await categotyService.getCategories();
    //HTTPReult demoCategory = await categotyService.deleteCategory(categoryId: "bird_tag");
    //List<Orders>? orders = await orderService.getOrdersbyID(orderID: "8678f767-712b-4ea0-ade8-0472d48af379");
    //HTTPReult txtAPI = await orderService.deleteOrder(orderID: "1ca738c5-df08-4581-aa22-8070eb6cacc7");
    List<orderItems>? listOrrderItems = await orderItemService.getOrderItemsbyOrderID(orderID: '04bc09ea-9352-4a2d-8c81-02278f2450f8');

    // List<Map<String, dynamic>> dataItem = [
    //   {
    //     "orderItemID": "24bcef8a-2f7c-6f9e-64ca-c2c49e6aef15",
    //     "orderID": "04bc09ea-9352-4a2d-8c81-02278f2450f8",
    //     "productID": "24bdbf8a-0f7e-3f9e-85ca-c2c49e6aef15",
    //     "quantity": 2,
    //     "price": 40000
    //   },
    //   {
    //     "orderItemID": "24bcef8a-2f7c-6f9e-64ca-c2c49e6aef15",
    //     "orderID": "04bc09ea-9352-4a2d-8c81-02278f2450f8",
    //     "productID": "24bdbf8a-0f7e-3f9e-85ca-c2c49e6aef15",
    //     "quantity": 3,
    //     "price": 40000
    //   },
    //   {
    //     "orderItemID": "24bcef8a-2f7e-6f9e-85ca-c2c49e6aef15",
    //     "orderID": "04bc09ea-9352-4a2d-8c81-02278f2450f8",
    //     "productID": "24bdbf8a-0f7e-3f9e-85ca-c2c49e6aef15",
    //     "quantity": 10,
    //     "price": 100000
    //   }
    // ];

    //HTTPReult testAPI = await orderItemService.createOrderWithItems(dataItem);
    //List<Cart>? listcart = await cartService.getCarts();
    //List<cartItems>? listCartItems = await cartItemService.getCartItems();
    //HTTPReult democode = await cartItemService.createCartItem(cartID: "4a3bf369-62be-459e-b49c-9a3d25fd3767", productID: "24bdbf8a-0f7e-3f9e-85ca-c2c49e6aef15");
    //List<payment>? listpayments = await paymentService.getPayments();
    var uuid = Uuid();

    //HTTPReult democode = await paymentService.removePayment(payment_id: 'a4b8e6d1-f2a6-4938-b714-bb4b07e3e964');
    List<voucher>? vouchers = await voucherService.getVoucherbyDate(startDate: "29/8/2024", endDate: "5/9/2024");
    // HTTPReult democode = await voucherService.createVoucher(datavoucher: {
    //   "voucher_id": uuid.v4().toString(),
    //   "code": "demo2",
    //   "discount": 0.4,
    //   "expiryDate": DateTime.now().toIso8601String(),
    //   "minOrder": 10000
    // });

    //HTTPReult democode = await voucherService.removeVoucher(voucher_id: "d7c004ff-72aa-428d-9a63-03b2f608512c");

    //List<voucherUse>? listVoucheruse = await voucheruseService.getVoucherUsebyUserID(userID: "e6967d0d-70ce-30a2-af5f-759e4cd7aa79");
    //HTTPReult democode = await voucheruseService.addVoucherUse(userID: "e6967d0d-70ce-30a2-af5f-759e4cd7aa79", voucherID: "43e5a380-7740-458c-82d4-9dc4f45bff42");
    HTTPReult democode = await userService.checkpass(username: "Duy2822005", password: "Duy2822005@");

    setState(() {
      //text = '${created_produce}';
      text = '${democode}';
    });

    //print(jsonEncode(products));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(text)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
