import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppet_fontend/Widget/expandText.dart';

class detailScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _detailScreen();

}

class _detailScreen extends State<detailScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(232, 124, 0, 1.0),),
          onPressed: () {
            //Navigator.pop(context);
          },
        ),
        title: const Text("Detail Product", style: TextStyle(fontFamily: "Itim"),),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.shopping_cart_rounded))
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/Image/product.png", width: MediaQuery.sizeOf(context).width, height: 250, fit : BoxFit.fill,),
                const Padding(padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star_outlined, color: Colors.orangeAccent, size: 20,),
                          SizedBox(width: 5,),
                          Text("4.5", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                          SizedBox(width: 5,),
                          Text("(150)", style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                      Text("Nhà Mèo Lông", style: TextStyle(fontFamily: "Itim", fontSize: 30),),
                      Text("70.000 VNĐ", style: TextStyle(fontSize: 20, fontFamily: "Itim", color: Color.fromRGBO(232, 124, 0, 1.0)),),
                      Text("Mô Tả Chi Tiết", style: TextStyle(fontFamily: "Itim"),),
                    ],
                  ),
                ),
                const ExpandableText(
                  text: "Mô tả sản phẩm: Chuồng mèo cao cấp\nChuồng mèo cao cấp là không gian lý tưởng để thú cưng của bạn có thể nghỉ ngơi và vui chơi an toàn. Thiết kế rộng rãi, thoáng mát với nhiều tầng và kệ giúp mèo dễ dàng leo trèo, vận động, và quan sát môi trường xung quanh. Chất liệu thép không gỉ kết hợp với lớp sơn tĩnh điện giúp chuồng có độ bền cao, chống gỉ sét và an toàn cho mèo. Cửa chuồng thiết kế khóa an toàn, dễ dàng đóng mở.\n\nChuồng phù hợp sử dụng trong nhà hoặc ngoài trời, mang lại không gian tiện nghi cho thú cưng và sự an tâm cho bạn.",
                ),

                const Divider(
                  color: Color.fromRGBO(219, 219, 219, 1.0),  // Màu của đường gạch ngang
                  thickness: 6.0,      // Độ dày của đường gạch ngang
                  indent: 0.0,        // Khoảng cách từ mép trái đến bắt đầu của đường gạch ngang
                  endIndent: 0.0,     // Khoảng cách từ mép phải đến cuối của đường gạch ngang
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

}