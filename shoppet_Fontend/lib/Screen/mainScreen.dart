import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:shoppet_fontend/API/Server/productAPI.dart';
import 'package:shoppet_fontend/API/Server/rateAPI.dart';
import 'package:shoppet_fontend/Model/apiModel/productModel.dart';
import 'package:shoppet_fontend/Screen/detailScreen.dart';
import 'package:shoppet_fontend/Screen/searchScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Model/apiModel/rateModel.dart';
import '../Model/apiModel/userModel.dart';
import '../Widget/startDisplay.dart';
import 'categoryScreen.dart';

class screenMain extends StatefulWidget{

  final Function() togetherNavBar;

  const screenMain({super.key, required this.togetherNavBar});

  @override
  State<StatefulWidget> createState() => _screenMain();

}

class _screenMain extends State<screenMain>{

  late final PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  List<Rate>? ListRate = [];

  List<dynamic> caluteRate(String productID){
    int sumRate = 0;
    int amount = 0;
    ListRate!.forEach((rate){
      if(productID == rate.productID){
        sumRate += rate.rate;
        amount++;
      }
    });

    return [amount == 0 ? 0.0: double.parse((sumRate/amount).toStringAsFixed(1)), amount];
  }


  Future<List<Product>> getProducts() async {
    productAPI productService = productAPI();
    rateAPI rateServiece = rateAPI();
    List<Product>? listProduct = await productService.getProducts();
    ListRate = await rateServiece.getRates();

    print(listProduct);

    return listProduct ?? <Product>[];
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);

    // Thiết lập Timer để tự động cuộn sau mỗi 2 giây
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en'); // Định dạng sử dụng dấu phẩy
    return formatter.format(amount).replaceAll(',', '.'); // Thay dấu phẩy bằng dấu chấm
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getProducts(), builder: (context, dataProduct){
      if(dataProduct.connectionState == ConnectionState.waiting){
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        );
      }

      if(dataProduct.hasError){
        return const Center(child: Text("error"),);
      }

      if(dataProduct.hasData){
        List<Product> listRandom = [];
        Random random = Random();
        for(int i = 0; i < 5; i++){
          listRandom.add(dataProduct.data![random.nextInt(dataProduct.data!.length)]);
        }

        return loadScreen(true, listRandom, dataProduct.data!);
      }else{
        return loadScreen(false);
      }

    });
  }

  Widget loadScreen(bool hasData, [List<Product> listData = const [], List<Product> listDataAll = const []]){
    return Container(
      color: Colors.white,
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        color: Colors.white,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                Row(
                  children: [
                    const SizedBox(width: 10,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(360.0), // Đường kính của border (50/2)
                      child: Image.asset(
                        "assets/Image/logoShopPet_1.png",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover, // Để hình ảnh không bị biến dạng
                      ),
                    ),
                    const SizedBox(width: 10,),
                    const Expanded(
                      child: Text("Shop Pet", style: TextStyle(fontFamily: "JustAnotherHand", fontSize: 30, decoration: TextDecoration.none, color: Color.fromRGBO(232, 124, 0, 1.0))),
                    ),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_none, color: Colors.grey,))
                  ],
                ),
                const SizedBox(height: 10,),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      widget.togetherNavBar();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => searchScreen(listProductFamous: listData, togeNavabar: (){
                        widget.togetherNavBar();
                      })));
                    } ,
                    child: Container(
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Stack(
                    children: [
                      Container(
                        height: 120, // Chiều cao của banner
                        child: PageView(
                          controller: _pageController,
                          children: [
                            Image.asset("assets/Image/BannerADS/banner1.png"),
                            Image.asset("assets/Image/BannerADS/banner1.png"),
                            Image.asset("assets/Image/BannerADS/banner1.png"),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: 100,
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
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Category",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontFamily: "Jua",
                        fontSize: 15
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: (){
                            widget.togetherNavBar();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(categoryID: 'dog_tag', togeteNavBar: (){
                              widget.togetherNavBar();
                            },)));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(252, 232, 173, 1.0), // Màu nền của Container
                                  borderRadius: BorderRadius.circular(10.0), // Bo tròn góc
                                ),
                                child: Align(
                                  alignment: Alignment.center, // Căn giữa ảnh trong container
                                  child: SizedBox(
                                    width: 25, // Đặt kích thước chiều rộng cho ảnh
                                    height: 25, // Đặt kích thước chiều cao cho ảnh
                                    child: Image.asset(
                                      "assets/Image/IconCategory/dog.png",
                                      fit: BoxFit.contain, // Đảm bảo ảnh không lấp đầy container
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("Dog", style: TextStyle(color: Colors.black, fontSize: 10, decoration: TextDecoration.none, fontFamily: "Mina", fontWeight: FontWeight.w100),),
                            ],
                          )
                      ),
                      GestureDetector(
                          onTap: (){
                            widget.togetherNavBar();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(categoryID: 'cat_tag', togeteNavBar: (){
                              widget.togetherNavBar();
                            },)));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(252, 232, 173, 1.0), // Màu nền của Container
                                  borderRadius: BorderRadius.circular(10.0), // Bo tròn góc
                                ),
                                child: Align(
                                  alignment: Alignment.center, // Căn giữa ảnh trong container
                                  child: SizedBox(
                                    width: 25, // Đặt kích thước chiều rộng cho ảnh
                                    height: 25, // Đặt kích thước chiều cao cho ảnh
                                    child: Image.asset(
                                      "assets/Image/IconCategory/cat.png",
                                      fit: BoxFit.contain, // Đảm bảo ảnh không lấp đầy container
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("Cat", style: TextStyle(color: Colors.black, fontSize: 10, decoration: TextDecoration.none, fontFamily: "Mina", fontWeight: FontWeight.w100),),
                            ],
                          )
                      ),
                      GestureDetector(
                          onTap: (){
                            widget.togetherNavBar();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(categoryID: 'bird_tag', togeteNavBar: (){
                              widget.togetherNavBar();
                            },)));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(252, 232, 173, 1.0), // Màu nền của Container
                                  borderRadius: BorderRadius.circular(10.0), // Bo tròn góc
                                ),
                                child: Align(
                                  alignment: Alignment.center, // Căn giữa ảnh trong container
                                  child: SizedBox(
                                    width: 25, // Đặt kích thước chiều rộng cho ảnh
                                    height: 25, // Đặt kích thước chiều cao cho ảnh
                                    child: Image.asset(
                                      "assets/Image/IconCategory/bird.png",
                                      fit: BoxFit.contain, // Đảm bảo ảnh không lấp đầy container
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("Bird", style: TextStyle(color: Colors.black, fontSize: 10, decoration: TextDecoration.none, fontFamily: "Mina", fontWeight: FontWeight.w100),),
                            ],
                          )
                      ),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(categoryID: 'turtle_tag', togeteNavBar: (){
                              widget.togetherNavBar();
                            },)));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(252, 232, 173, 1.0), // Màu nền của Container
                                  borderRadius: BorderRadius.circular(10.0), // Bo tròn góc
                                ),
                                child: Align(
                                  alignment: Alignment.center, // Căn giữa ảnh trong container
                                  child: SizedBox(
                                    width: 25, // Đặt kích thước chiều rộng cho ảnh
                                    height: 25, // Đặt kích thước chiều cao cho ảnh
                                    child: Image.asset(
                                      "assets/Image/IconCategory/turtle.png",
                                      fit: BoxFit.contain, // Đảm bảo ảnh không lấp đầy container
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("Turtle", style: TextStyle(color: Colors.black, fontSize: 10, decoration: TextDecoration.none, fontFamily: "Mina", fontWeight: FontWeight.w100),),
                            ],
                          )
                      ),
                      GestureDetector(
                          onTap: (){
                            widget.togetherNavBar();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(categoryID: 'rabbit_tag', togeteNavBar: (){
                              widget.togetherNavBar();
                            },)));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(252, 232, 173, 1.0), // Màu nền của Container
                                  borderRadius: BorderRadius.circular(10.0), // Bo tròn góc
                                ),
                                child: Align(
                                  alignment: Alignment.center, // Căn giữa ảnh trong container
                                  child: SizedBox(
                                    width: 25, // Đặt kích thước chiều rộng cho ảnh
                                    height: 25, // Đặt kích thước chiều cao cho ảnh
                                    child: Image.asset(
                                      "assets/Image/IconCategory/rabbit.png",
                                      fit: BoxFit.contain, // Đảm bảo ảnh không lấp đầy container
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("Rabbit", style: TextStyle(color: Colors.black, fontSize: 10, decoration: TextDecoration.none, fontFamily: "Mina", fontWeight: FontWeight.w100),),
                            ],
                          )
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(252, 232, 173, 1.0), // Màu nền của Container
                                borderRadius: BorderRadius.circular(10.0), // Bo tròn góc
                              ),
                              child: Align(
                                alignment: Alignment.center, // Căn giữa ảnh trong container
                                child: SizedBox(
                                  width: 25, // Đặt kích thước chiều rộng cho ảnh
                                  height: 25, // Đặt kích thước chiều cao cho ảnh
                                  child: Image.asset(
                                    "assets/Image/IconCategory/other.png",
                                    fit: BoxFit.contain, // Đảm bảo ảnh không lấp đầy container
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Other",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  decoration: TextDecoration.none,
                                  fontFamily: "Mina",
                                  fontWeight: FontWeight.w100
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const Divider(
                  color: Color.fromRGBO(219, 219, 219, 1.0),  // Màu của đường gạch ngang
                  thickness: 6.0,      // Độ dày của đường gạch ngang
                  indent: 0.0,        // Khoảng cách từ mép trái đến bắt đầu của đường gạch ngang
                  endIndent: 0.0,     // Khoảng cách từ mép phải đến cuối của đường gạch ngang
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
                      child: listData.isEmpty ? Center(
                        child: Image.asset("assets/Image/nodata.png"), // Hiển thị ảnh khi không có dữ liệu
                      )
                          : ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (Product item in listData)
                            viewProduct(4.5, formatCurrency(item.price), item),
                        ],
                      ),
                    )
                ),

                const Divider(
                  color: Color.fromRGBO(219, 219, 219, 1.0),  // Màu của đường gạch ngang
                  thickness: 6.0,      // Độ dày của đường gạch ngang
                  indent: 0.0,        // Khoảng cách từ mép trái đến bắt đầu của đường gạch ngang
                  endIndent: 0.0,     // Khoảng cách từ mép phải đến cuối của đường gạch ngang
                ),

                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Danh Sách Sản Phẩm",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontFamily: "Jua",
                        fontSize: 15
                    ),
                  ),
                ),
                const Divider(
                  color: Color.fromRGBO(219, 219, 219, 1.0),  // Màu của đường gạch ngang
                  thickness: 1.0,      // Độ dày của đường gạch ngang
                  indent: 0.0,        // Khoảng cách từ mép trái đến bắt đầu của đường gạch ngang
                  endIndent: 0.0,     // Khoảng cách từ mép phải đến cuối của đường gạch ngang
                ),

                // GridView.count(
                //   crossAxisCount: 2, // Số cột trong lưới
                //   children: List.generate(listDataAll.length, (index) {
                //     return viewProduct(4.5, formatCurrency(listDataAll[index].price), listDataAll[index]);
                //   })
                // )
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 250,
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      itemCount: listDataAll.length,
                      //mainAxisSpacing: ,
                      //crossAxisSpacing: 2,

                      itemBuilder: (context, index) {
                        return viewProduct(4.5, formatCurrency(listDataAll[index].price), listDataAll[index]);
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      )
    );
  }

  Uint8List base64ToImage(String base64String) {
    return const Base64Decoder().convert(base64String);
  }


  Widget viewProduct(double star, String price, Product product){
    List<dynamic> listResult = caluteRate(product.product_id);

    return GestureDetector(
      onTap: (){
        setState(() {
          widget.togetherNavBar();
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => detailScreen(product: product, listResultRate: listResult, togeteNavBar: widget.togetherNavBar,)));
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