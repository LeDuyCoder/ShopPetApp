import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoppet_fontend/Screen/showSearchScreen.dart';

import '../Model/apiModel/productModel.dart';
import '../Model/apiModel/rateModel.dart';
import '../Widget/startDisplay.dart';
import 'detailScreen.dart';

class searchScreen extends StatefulWidget{

  final List<Product> listProductFamous;
  final Function togeNavabar;

  const searchScreen({super.key, required this.listProductFamous, required this.togeNavabar});

  @override
  State<StatefulWidget> createState() => _searchScreen();
  
}


class _searchScreen extends State<searchScreen>{
  List<String> listKeySearch = ["Nhà Cho Chó", "Vòng Cổ Mèo", "Đồ Chơi Cho Chó", "Thức Ăn Thú Cưng", "Lòng Nuôi Chim"];
  TextEditingController searchController = TextEditingController();
  List<Rate>? ListRate = [];

  List<dynamic> caluteRate(String productID){
    int sumRate = 0;
    int amount = 0;
    for (var rate in ListRate!) {
      if(productID == rate.productID){
        sumRate += rate.rate;
        amount++;
      }
    }

    return [amount == 0 ? 0.0: double.parse((sumRate/amount).toStringAsFixed(1)), amount];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(232, 124, 0, 1.0),),
                  onPressed: () {
                    widget.togeNavabar();
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 20, // Chiều cao tối thiểu
                          maxHeight: 35, // Chiều cao tối đa
                        ),
                        child: TextField(
                          controller: searchController,
                          style: const TextStyle(fontSize: 12),
                          // Giảm kích thước chữ
                          decoration: const InputDecoration(
                            hintText: "Tìm sản phẩm bạn muốn",
                            hintStyle: TextStyle(color: Colors.grey, fontFamily: "Mali"),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey
                              ),
                              gapPadding: 2,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 5), // Giảm padding nội dung
                          ),
                        ),
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => showSearchScreen(keySearchInput: searchController.text)));
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 232, 173, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(194, 188, 172, 1.0),
                                offset: Offset(2, 2)
                            )
                          ]
                      ),
                      child: const Icon(Icons.search_outlined, color: Color.fromRGBO(
                          255, 159, 114, 1.0),),
                    ),
                  ),
                )
              ],
            ),

            for(int i = 0; i < listKeySearch.length; i++)
              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => showSearchScreen(keySearchInput: listKeySearch[i])));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(listKeySearch[i], style: const TextStyle(fontFamily: "Mali", color: Colors.grey),),
                      ),
                      const Divider(
                        color: Color.fromRGBO(219, 219, 219, 1.0),
                        thickness: 2.0,
                        indent: 0.0,
                        endIndent: 0.0,
                      ),
                    ],
                  )
              ),

            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("Famous",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontFamily: "Jua",
                    fontSize: 15
                ),
              ),
            ),

            Padding(padding: EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  height: 180,
                  width: MediaQuery.sizeOf(context).width,
                  child: widget.listProductFamous.isEmpty ? Center(
                    child: Image.asset("assets/Image/nodata.png"), // Hiển thị ảnh khi không có dữ liệu
                  )
                      : ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (Product product in widget.listProductFamous)
                        viewProduct(caluteRate(product.product_id)[0]*1.0, formatCurrency(product.price), product)
                    ],
                  ),
                )
            ),

          ],
        ),
      ),
    );
  }
  
  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en'); // Định dạng sử dụng dấu phẩy
    return formatter.format(amount).replaceAll(',', '.'); // Thay dấu phẩy bằng dấu chấm
  }


  Uint8List base64ToImage(String base64String) {
    return const Base64Decoder().convert(base64String);
  }


  Widget viewProduct(double star, String price, Product product){
    List<dynamic> listResult = caluteRate(product.product_id);

    return GestureDetector(
      onTap: (){
        setState(() {
          //widget.togetherNavBar();
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => detailScreen(product: product, listResultRate: listResult, togeteNavBar: widget.togeNavabar(), runFunction: false,)));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: SizedBox(
          height: 180,
          width: 100,
          //color: Colors.greenAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 80,
                  child: product.image == "none"?
                  const Center(child: Icon(Icons.image_not_supported_outlined, size: 50, color: Colors.grey,))
                      : Center(child: Image.memory(base64ToImage(product.image)),)
              ),
              //Image.asset("assets/Image/noimage.png",),
              Text(product.name,
                style: const TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontFamily: "Itim",
                    fontSize: 15
                ),
              ),
              StarDisplayApp(value: listResult[0], size: 15,),
              Text("$price VNĐ",
                style: const TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontFamily: "Itim",
                    fontSize: 15
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}