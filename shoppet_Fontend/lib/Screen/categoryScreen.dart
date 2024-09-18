import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shoppet_fontend/API/Server/categoryAPI.dart';
import 'package:shoppet_fontend/API/Server/productAPI.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Model/apiModel/productModel.dart';
import '../Model/apiModel/categoryModel.dart';
import '../Model/apiModel/rateModel.dart';
import '../Widget/startDisplay.dart';
import 'detailScreen.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryID;
  final Function() togeteNavBar;

  const CategoryScreen({super.key, required this.categoryID, required this.togeteNavBar});

  @override
  State<StatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late final PageController _pageController;
  late Timer _timerPage;
  int _currentPage = 0;
  List<Rate>? ListRate = [];
  Category? category;

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

  String handldTitle(){
    return widget.categoryID.split("_")[0];
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);

    // Thiết lập Timer để tự động cuộn sau mỗi 5 giây
    _timerPage = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  Future<List<Product>> getProducts(String categoryID) async {
    productAPI productService = productAPI();
    categoryAPI categoryServicce = categoryAPI();
    List<Product>? listProduct = await productService.getProductByCategoryId(categoryID);
    List<Category>? listCategory = await categoryServicce.getCategories(categoryId: widget.categoryID);
    category = listCategory![0];
    return listProduct ?? [];
  }
  
  @override
  void dispose() {
    _timerPage.cancel(); // Dừng Timer khi màn hình bị huỷ
    _pageController.dispose(); // Huỷ bỏ PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      color: Colors.white,
      child: FutureBuilder(future: getProducts(widget.categoryID), builder: (context, listDataAll){
        if(listDataAll.connectionState == ConnectionState.waiting){
          return Center(
            child: Container(
              height: 50,
              width: 50,
              child: const CircularProgressIndicator(color: Colors.orange,),
            ),
          );
        }

        if(listDataAll.hasError){
          return Center(
              child: Center(
                child: Image.asset("assets/Image/404.png"),
              )
          );
        }

        if(listDataAll.hasData){
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color.fromRGBO(232, 124, 0, 1.0),
                ),
                onPressed: () {
                  widget.togeteNavBar();
                  Navigator.pop(context);
                },
              ),
              title: Text(handldTitle(), style: const TextStyle(fontFamily: "Itim", fontWeight: FontWeight.bold),),
            ),
            body: Column(
              children: [
                SizedBox(
                    height: 150, // Chiều cao của banner
                    child: Stack(
                      children: [
                        PageView(
                          controller: _pageController,
                          children: [
                            Image.asset("assets/Image/BannerADS/baner.png"),
                            Image.asset("assets/Image/BannerADS/baner.png"),
                            Image.asset("assets/Image/BannerADS/baner.png"),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery
                              .sizeOf(context)
                              .width,
                          height: 140,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SmoothPageIndicator(
                              controller: _pageController,
                              count: 3, // Số lượng banner
                              effect: const WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                spacing: 16,
                                activeDotColor: Colors.grey,
                                dotColor: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 60,
                        height: 60,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Container(
                                  height: 20,
                                  width: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(2)),
                                  ),
                                  child: const Center(
                                    child: Text("Yêu Thích", style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Itim",
                                        fontSize: 10)),
                                  )
                              )
                          ),
                        )
                    ),
                    Expanded(
                      child: Container(
                        height: 60,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(category!.name,
                              style: const TextStyle(color: Colors.black,
                                  fontFamily: "Itim",
                                  fontSize: 20)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Color.fromRGBO(219, 219, 219, 1.0),
                  // Màu của đường gạch ngang
                  thickness: 6.0,
                  // Độ dày của đường gạch ngang
                  indent: 0.0,
                  // Khoảng cách từ mép trái đến bắt đầu của đường gạch ngang
                  endIndent: 0.0, // Khoảng cách từ mép phải đến cuối của đường gạch ngang
                ),

                DefaultTabController(
                  length: 2,
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
                              text: "Sản Phẩm Bán Chạy",
                            ),
                            Tab(
                                text: "Tồn Kho"
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: <Widget>[
                              Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 250,
                                      child: listDataAll.data!.isEmpty ? Center(
                                        child: Image.asset("assets/Image/noproduct.png", width: 250,),
                                      ) :  MasonryGridView.count(
                                        crossAxisCount: 2,
                                        itemCount: listDataAll.data!.length,
                                        //mainAxisSpacing: ,
                                        //crossAxisSpacing: 2,
  
                                        itemBuilder: (context, index) {
                                          return viewProduct(4.5, formatCurrency(listDataAll.data![index].price), listDataAll.data![index]);
                                        },
                                      ),
                                    ),
                                  )
                              ),
                              Center(
                                  child: Center(
                                    child: Image.asset(
                                      "assets/Image/noproduct.png", width: 250,),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }else{
          return Center(
            child: Center(
              child: Image.asset("assets/Image/404.png"),
            )
          );
        }
      }),
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
          widget.togeteNavBar();
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => detailScreen(product: product, listResultRate: listResult, togeteNavBar: widget.togeteNavBar,)));
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
