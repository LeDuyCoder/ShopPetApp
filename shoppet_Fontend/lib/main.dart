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
        home: const SladeSceen());
  }
}
