import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoppet_fontend/API/Server/rateAPI.dart';
import 'package:shoppet_fontend/API/Server/userAPI.dart';
import 'package:shoppet_fontend/Model/apiModel/productModel.dart';
import 'package:shoppet_fontend/Widget/expandText.dart';

import '../Model/apiModel/rateModel.dart';
import '../Model/apiModel/userModel.dart';
import '../Widget/startDisplay.dart';

class detailScreen extends StatefulWidget{

  final Product product;
  final List<dynamic> listResultRate;

  const detailScreen({super.key, required this.product, required this.listResultRate});

  @override
  State<StatefulWidget> createState() => _detailScreen();

}

class _detailScreen extends State<detailScreen>{

  Uint8List base64ToImage(String base64String) {
    return const Base64Decoder().convert(base64String);
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en'); // Định dạng sử dụng dấu phẩy
    return formatter.format(amount).replaceAll(',', '.'); // Thay dấu phẩy bằng dấu chấm
  }




  Future<Map<User, List<Rate>>> loadComment(String ProductID) async {
    final rateService = rateAPI();
    final userService = userAPI();
    final listRates = await rateService.getRatesByProductID(ProductID) ?? [];

    final userIds = listRates.map((rate) => rate.userID).toSet();
    final listUsers = await userService.getUsersByIds(userIds.toList()) ?? [];

    final userMap = Map.fromEntries(listUsers.map((user) => MapEntry(user.userId, user)));

    final commentsMap = listRates.fold<Map<User, List<Rate>>>({}, (map, rate) {
      final user = userMap[rate.userID];
      if (user != null) {
        map[user] = (map[user] ?? [])..add(rate);
      }
      return map;
    });
    print(commentsMap);
    return commentsMap;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(232, 124, 0, 1.0),),
          onPressed: () {
            Navigator.pop(context);
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
                  widget.product.image == "none" ? const Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 100,),): Image.memory(base64ToImage(widget.product.image), width: MediaQuery.sizeOf(context).width, height: 250, fit : BoxFit.fill,),
                  Padding(padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_outlined, color: Colors.orangeAccent, size: 20,),
                            const SizedBox(width: 5,),
                            Text("${widget.listResultRate[0]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                            const SizedBox(width: 5,),
                            Text("(${widget.listResultRate[1]})", style: const TextStyle(color: Colors.grey),)
                          ],
                        ),
                        Text(widget.product.name, style: const TextStyle(fontFamily: "Itim", fontSize: 30),),
                        Text("${formatCurrency(widget.product.price)} VNĐ", style: TextStyle(fontSize: 20, fontFamily: "Itim", color: Color.fromRGBO(232, 124, 0, 1.0)),),
                        const Text("Mô Tả Chi Tiết", style: TextStyle(fontFamily: "Itim"),),
                      ],
                    ),
                  ),
                  ExpandableText(
                    text: widget.product.description.replaceAll("\\n", "\n"),
                  ),

                  const Divider(
                    color: Color.fromRGBO(219, 219, 219, 1.0),  // Màu của đường gạch ngang
                    thickness: 6.0,      // Độ dày của đường gạch ngang
                    indent: 0.0,        // Khoảng cách từ mép trái đến bắt đầu của đường gạch ngang
                    endIndent: 0.0,     // Khoảng cách từ mép phải đến cuối của đường gạch ngang
                  ),
                ],
              ),

              const Padding(padding: EdgeInsets. only(left: 5, top: 5),
                child: Text("Đánh Giá", style: TextStyle(fontFamily: "Itim", fontSize: 20),),
              ),

              FutureBuilder(future: loadComment(widget.product.product_id), builder: (context, dataComment){
                if(dataComment.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator(color: Colors.orange);
                }

                if(dataComment.hasData){
                  return loadWidgetComment(dataComment.data!);
                }else{
                  return Center(
                    child: Image.asset("assets/Image/nodata.png", width: 150,),
                  );
                }
              }),
            ],
          )
      )
    );
  }

  Widget loadWidgetComment(Map<User, List<Rate>> listData ){
    List<Widget> comments = [];

    listData.forEach((User user, List<Rate> Datacomments){
      Datacomments.forEach((comment){
        comments.add(
          Padding(padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias, // Cắt hình ảnh theo đường viền hình tròn
                  child: user.image == "" ? Image.asset(
                          "assets/Image/logoShopPet_1.png",
                          fit: BoxFit.cover, // Điều chỉnh hình ảnh để vừa với hình tròn
                        ): Image.memory(base64ToImage(user.image),fit: BoxFit.cover,),
                ),
                const SizedBox(width: 5,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(user.name, style: TextStyle(fontFamily: "Itim"),),
                          const SizedBox(width: 5),
                          StarDisplayApp(value: comment.rate*1.0, size: 10,),
                        ],
                      ),
                      Text(comment.comment,
                        style: const TextStyle(fontFamily: "Itim", color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const Row(
                  children: [
                    SizedBox(width: 4,),
                    Text("Reply", style: TextStyle(fontFamily: "itim", fontSize: 12, color: Colors.grey),),
                    SizedBox(width: 5,),
                    Icon(Icons.redo, size: 12, color: Colors.grey,)
                  ],
                )
              ],
            ),
          ),
        );
      });
    });


    return Column(
      children: [
        for(Widget comment in comments)
          comment
      ],
    );
  }

}