import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppet_fontend/API/Server/orderAPI.dart';
import 'package:shoppet_fontend/API/Server/orderItemAPI.dart';
import 'package:shoppet_fontend/Model/apiModel/orderModel.dart';

import '../Model/apiModel/orderItemModel.dart';
import '../Model/apiModel/userModel.dart';
import '../Widget/statusOder.dart';

class orderScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _orderScreen();
}

class _orderScreen extends State<orderScreen>{

  Future<List<Map<String, dynamic>>> getDataOrder() async {
    SharedPreferences storeData = await SharedPreferences.getInstance();
    User user = User.fromJson(jsonDecode(storeData.getString("dataUser")!));
    orderItemAPI orderItemService = orderItemAPI();
    orderAPI orderService = orderAPI();

    List<Orders>? listOrders = await orderService.getOrdersbyUserID(userID: user.userId);
    List<Map<String, dynamic>> listData = [];

    for (Orders order in listOrders!) {
      if (storeData.containsKey("order.${order.order_id}")) {
        listData.add(jsonDecode(storeData.getString("order.${order.order_id}")!));
      } else {
        List<orderItems>? listOrderItem = await orderItemService.getOrderItemsbyOrderID(orderID: order.order_id);

        double sumPrice = 0.0;
        listOrderItem!.forEach((item) {
          sumPrice += item.price;
        });

        Map<String, dynamic> dataResult = {
          "id": order.order_id,
          "itemAmount": listOrderItem.length,
          "status": order.status,
          "total_price": order.total_price,
          "origin_price": sumPrice,
        };

        listData.add(dataResult);
        await storeData.setString("order.${order.order_id}", jsonEncode(dataResult));
      }
    }

    return listData;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back, color: Color.fromRGBO(232, 124, 0, 1.0))),
        title: Text("Orders", style: TextStyle(fontFamily: "Itim")),
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width-30, // Độ rộng của Container
              height: 30, // Chiều cao của Container
              decoration: BoxDecoration(
                color: Colors.white, // Màu nền của Container
                border: Border.all(
                  color: Colors.grey, // Màu của border
                  width: 1.0, // Độ dày của border
                ),
                borderRadius: BorderRadius.circular(5), // Bo tròn các góc của border (tùy chọn)
              ),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.search_outlined, size: 20,),
                  ),
                  Expanded(child: Text("find your product you want", style: TextStyle(decoration: TextDecoration.none, color: Colors.grey, fontSize: 10, fontFamily: "Mali"),)),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.filter_list, size: 20,)
                  )
                ],
              ),
            ),
            DefaultTabController(
              length: 1,
              child: Expanded(
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Color.fromRGBO(232, 124, 0, 1.0),
                      indicatorColor: Color.fromRGBO(232, 124, 0, 1.0),
                      labelStyle: TextStyle(
                          fontSize: 13
                      ),
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: <Widget>[
                        Tab(
                          text: "ALL",
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            child: FutureBuilder(future: getDataOrder(), builder: (context, data){
                              if(data.connectionState == ConnectionState.waiting){
                                return Container(
                                  height: 50,
                                  width: 50,
                                  child: const CircularProgressIndicator(
                                    color: Colors.orange,
                                  ),
                                );
                              }

                              if(data.hasError){
                                return Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset("assets/Image/404.png")
                                );
                              }

                              if(data.hasData){
                                return data.data!.isEmpty ? Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset("assets/Image/noproduct.png", width: 50,)
                                ) : Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: MediaQuery.sizeOf(context).height,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10,),
                                      Container(
                                        width: MediaQuery.sizeOf(context).width - 20,
                                        height: MediaQuery.sizeOf(context).height - 200,
                                        child: ListView(
                                          scrollDirection: Axis.vertical,
                                          children: [
                                            for(Map<String, dynamic> dataResult in data.data!)
                                              orderBuildWidget(dataResult),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }else{
                                return Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset("assets/Image/noproduct.png", width: 50)
                                );
                              }
                            }),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en'); // Định dạng sử dụng dấu phẩy
    return formatter.format(amount).replaceAll(',', '.'); // Thay dấu phẩy bằng dấu chấm
  }

  Widget orderBuildWidget(Map<String, dynamic> dataOrder){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
          width: MediaQuery.sizeOf(context).width - 20,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[80],
            border: Border.all(
                color: Colors.orange
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                 Row(
                  children: [
                    const Text("ID", style: TextStyle(color: Colors.grey, fontSize: 12, fontFamily: "Itim"),),
                    const SizedBox(width: 5),
                    Text(dataOrder["id"], style: TextStyle(fontSize: 12, fontFamily: "Itim"),)
                  ],
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width - 30,
                  height: 81,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 5,),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${dataOrder["itemAmount"]} Items", style: const TextStyle(fontFamily: "Mina", fontSize: 13),),
                          Text("${formatCurrency(dataOrder["origin_price"])} VNĐ", style: TextStyle(fontFamily: "Mina", fontSize: 13))
                        ],
                      ),
                      const Divider(
                        color: Color.fromRGBO(219, 219, 219, 1.0),  // Màu của đường gạch ngang
                        thickness: 1.0,      // Độ dày của đường gạch ngang
                        indent: 10.0,        // Khoảng cách từ mép trái đến bắt đầu của đường gạch ngang
                        endIndent: 10.0,     // Khoảng cách từ mép phải đến cuối của đường gạch ngang
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Status", style: TextStyle(fontFamily: "Mina", fontSize: 13),),
                          dataOrder["status"] == "paid" ? statusOrder.statusPayed() : dataOrder["status"] == "fail" ? statusOrder.statusFail() : dataOrder["status"] == "Pending" ? statusOrder.statusPending() : statusOrder.statusCashed()
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Payment", style: TextStyle(fontFamily: "Mina", fontSize: 15, fontWeight: FontWeight.bold),),
                          Text("${formatCurrency(dataOrder["total_price"])} VNĐ", style: TextStyle(fontFamily: "Mina", fontSize: 15, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

}