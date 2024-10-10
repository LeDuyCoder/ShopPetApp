import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:shoppet_fontend/API/Server/productAPI.dart';

import '../Model/apiModel/categoryModel.dart';
import '../Model/apiModel/productModel.dart';
import '../Model/apiModel/rateModel.dart';
import '../Widget/startDisplay.dart';
import 'detailScreen.dart';
import 'detailScreen.dart';

class showSearchScreen extends StatefulWidget{

  final String keySearchInput;

  const showSearchScreen({super.key, required this.keySearchInput});

  @override
  State<StatefulWidget> createState() => _showSearchScreen();

}

class _showSearchScreen extends State<showSearchScreen>{
  TextEditingController searchText = TextEditingController();
  List<Rate>? ListRate = [];
  Category? category;
  String keySearch = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keySearch = widget.keySearchInput;
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en'); // Định dạng sử dụng dấu phẩy
    return formatter.format(amount).replaceAll(',', '.'); // Thay dấu phẩy bằng dấu chấm
  }

  List<dynamic> caluteRate(String productID) {
    int sumRate = 0;
    int amount = 0;
    ListRate!.forEach((rate) {
      if (productID == rate.productID) {
        sumRate += rate.rate;
        amount++;
      }
    });

    return [
      amount == 0 ? 0.0 : double.parse((sumRate / amount).toStringAsFixed(1)),
      amount
    ];
  }

  Future<List<Product>> getProducts(String name) async {
    productAPI productService = productAPI();
    List<Product>? listProduct = await productService.searchProductByName(name);
    return listProduct ?? [];

  }

  @override
  Widget build(BuildContext context) {
    searchText.text = keySearch;
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
                    //widget.togeNavabar();
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
                        controller: searchText,
                        style: const TextStyle(fontSize: 12),
                        // Giảm kích thước chữ
                        decoration: const InputDecoration(
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
                        setState(() {
                          keySearch = searchText.text;
                        });
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
                    )
                )
              ],
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
                          text: "Liên Quan",
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          Center(
                            child: FutureBuilder(future: getProducts(keySearch), builder: (context, dataProduct){
                              if(dataProduct.connectionState == ConnectionState.waiting){
                                return Container(
                                  height: 50,
                                  width: 50,
                                  child: const CircularProgressIndicator(
                                    color: Colors.orangeAccent,
                                  ),
                                );
                              }

                              if(dataProduct.hasError){
                                return Image.asset("assets/Image/404.png");
                              }

                              if(dataProduct.hasData){
                                List<Product> listProducts = dataProduct.data!;
                                return Padding(padding: EdgeInsets.only(left: 10, right: 10),
                                    child: Center(
                                      child: listProducts.isEmpty ? Image.asset("assets/Image/noproduct.png") : MasonryGridView.count(
                                        crossAxisCount: 2,
                                        itemCount: listProducts.length,
                                        itemBuilder: (context, index) {
                                          return viewProduct(caluteRate(listProducts[index].product_id)[0]*1.0, formatCurrency(listProducts[index].price), listProducts[index]);
                                        },
                                      ),
                                    )
                                );
                              }else{
                                return Image.asset("assets/Image/noproduct.png");
                              }
                            }),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Uint8List base64ToImage(String base64String) {
    return const Base64Decoder().convert(base64String);
  }

  Widget viewProduct(double star, String price, Product product) {
    List<dynamic> listResult = caluteRate(product.product_id);

    return GestureDetector(
      onTap: () {
        setState(() {
          //widget.togeteNavBar();
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => detailScreen(product: product, listResultRate: listResult, togeteNavBar: (){}, runFunction: false,)));
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
                  child: product.image == "none" ?
                  const Center(child: Icon(
                    Icons.image_not_supported_outlined, size: 50,
                    color: Colors.grey,))
                      : Center(
                    child: Image.memory(base64ToImage(product.image)),)
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