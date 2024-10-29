import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppet_fontend/Screen/SlashSceen.dart';

class orderSuccessScreen extends StatefulWidget{
  final String mahoadon, nameCustomer, AddressCustomer;
  final BuildContext invoiceContext;

  final void Function() clearDataCartScreen;
  final void Function() togeterNav;

  const orderSuccessScreen({super.key, required this.mahoadon, required this.nameCustomer, required this.AddressCustomer, required this.invoiceContext, required this.clearDataCartScreen, required this.togeterNav});

  @override
  State<StatefulWidget> createState() => _orderSuccessScreen();

}

class _orderSuccessScreen extends State<orderSuccessScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            SizedBox(height: 50,),
            Container(
              height: 450,
              width: MediaQuery.sizeOf(context).width - 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.greenAccent,
                    width: 5
                  )
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 20,
                    offset: Offset(-1, -1)
                  )
                ]
              ),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  const Center(
                    child: Icon(Icons.check_circle, color: Colors.green, size: 80,),
                  ),
                  const Text("Đặt Hàng Thành Công", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Text("Mã Đơn Hàng: #${widget.mahoadon}"),
                  const SizedBox(height: 20,),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: DottedLine(
                      direction: Axis.horizontal,
                      lineLength: double.infinity,
                      lineThickness: 2.0,
                      dashLength: 5.0,
                      dashGapLength: 2.0,
                      dashColor: Colors.grey,
                      alignment: WrapAlignment.center,
                    ),
                  ),
                  const SizedBox(height: 50,),
                  const Text("Thông Tin Giao Hàng", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10,),
                  Text(widget.nameCustomer),
                   Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(widget.AddressCustomer, textAlign: TextAlign.center,),
                  ),
                  const SizedBox(height: 20,),
                  const Text("Phương Thức Thanh Toán", style: TextStyle(fontWeight: FontWeight.bold),),
                  const Text("Thanh Toán Khi Giao Hàng (OCD)"),
                ],
              ),
            ),
            const SizedBox(height: 50,),
            GestureDetector(
              onTap: (){
                widget.clearDataCartScreen();
                Navigator.pop(widget.invoiceContext);
                widget.togeterNav();
                setState(() {
                  Slashsceen.cartItemsUser[0].clear();
                });
                Navigator.pop(context);
              },
              child: const Text("Tiếp Tục Mua Hàng" , style: TextStyle(decoration: TextDecoration.underline,)),
            )
          ],
        ),
      ),
    );
  }

}