import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class screenMain extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _screenMain();

}

class _screenMain extends State<screenMain>{

  late final PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
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
                  "assets/logoShopPet_1.png",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover, // Để hình ảnh không bị biến dạng
                ),
              ),
              const SizedBox(width: 10,),
              const Expanded(
                child: Text("Shop Pet", style: TextStyle(fontFamily: "JustAnotherHand", fontSize: 30, decoration: TextDecoration.none)),
              ),
              IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_none, color: Colors.grey,))
            ],
          ),
          SizedBox(height: 10,),
          Center(
            child: GestureDetector(
              onTap: (){} ,
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
                Container(
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
          )

        ],
      ),
    );
  }

}