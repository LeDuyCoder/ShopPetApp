import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppet_fontend/API/Server/cartAPI.dart';
import 'package:shoppet_fontend/API/Server/cartItemAPI.dart';
import 'package:shoppet_fontend/API/Server/productAPI.dart';
import 'package:shoppet_fontend/API/Server/voucherAPI.dart';
import 'package:shoppet_fontend/API/Server/voucherUseAPI.dart';
import 'package:shoppet_fontend/Model/apiModel/cartItemModel.dart';
import 'package:shoppet_fontend/Model/apiModel/productModel.dart';
import 'package:shoppet_fontend/Model/apiModel/voucherModel.dart';
import 'package:shoppet_fontend/Model/apiModel/voucherUseModel.dart';
import 'package:shoppet_fontend/Screen/SlashSceen.dart';
import 'package:shoppet_fontend/Screen/invoiceScreen.dart';

import '../Model/apiModel/cartModel.dart';
import '../Model/apiModel/userModel.dart';

class CartScreen extends StatefulWidget {
  final void Function() togetherNav;

  const CartScreen({super.key, required this.togetherNav});

  @override
  State<StatefulWidget> createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> {

  List<String> listID = [];
  Map<String, int> DataAmount = {};
  List<Product> listProduct = [];
  List<voucher> listVouchers = [];
  List<voucherUse> listVoucherUse = [];

  double sumPrice = 0;

  voucher? vouchercoding;

  TextEditingController code = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void clearData(){
    listProduct.clear();
    listID.clear();
    vouchercoding = null;
    DataAmount.clear();
  }

  void _clearCart() async {
    await _loadData();
    setState(() {
      Slashsceen.cartItemsUser[0].clear();
      vouchercoding = null;
      listProduct.clear();
      listID.clear();
      DataAmount.clear();
    });
  }

  Future<void> _loadData() async {
    listID.clear();

    // Chỉ xử lý khi cartItemsUser có dữ liệu
    if (Slashsceen.cartItemsUser[0].isNotEmpty) {
      Slashsceen.cartItemsUser[0].forEach((item) {
        listID.add(item.product_ID);
        DataAmount.putIfAbsent(item.product_ID, () => item.amount);
      });

      await loadDataDB(); // Đảm bảo loadDataDB hoàn tất
    }
  }

  Future<void> loadDataDB() async {
    listVouchers = await getVouchers();
    listVoucherUse = await getVoucherUse();
  }

  Future<List<voucherUse>> getVoucherUse() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    User dataUser = User.fromJson(jsonDecode(store.getString("dataUser")!));

    voucherUseAPI voucherUserService = voucherUseAPI();
    List<voucherUse>? listVoucherUse = await voucherUserService.getVoucherUsebyUserID(userID: dataUser.userId);

    return listVoucherUse ?? [];
  }


  Future<List<voucher>> getVouchers() async {
    voucherAPI voucherService = voucherAPI();

    List<voucher>? listVouchers = await voucherService.getVoucherbyDate(startDate: DateTime.now().toString());

    return listVouchers ?? [];
  }

  int getTotalItems() {
    int sum = 0;

    DataAmount.forEach((Id, amount){
      sum += amount;
    });
    return sum;
  }

  Future<double> getTotalPrice({int retryCount = 3}) async {
    // Gọi _loadData và đợi nó hoàn thành
    await _loadData();

    // Nếu listProduct rỗng và vẫn còn lượt retry, gọi lại đệ quy
    if (listProduct.isEmpty && retryCount > 0) {
      return getTotalPrice(retryCount: retryCount - 1);
    }

    // Nếu hết lượt thử mà vẫn không có dữ liệu, trả về 0
    if (listProduct.isEmpty) {
      return 0.0;
    }

    // Tính tổng giá trị
    double sum = 0;
    listProduct.forEach((product) {
      sum += product.price * (DataAmount[product.product_id] ?? 1);
    });

    return sum;
  }

  double getTotalPriceNoAsync() {
    double sum = 0;

    listProduct.forEach((product) {
      sum += product.price * (DataAmount[product.product_id] ?? 1);
    });

    return sum;
  }

  Uint8List base64ToImage(String base64String) {
    return const Base64Decoder().convert(base64String);
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en'); // Định dạng sử dụng dấu phẩy
    return formatter.format(amount).replaceAll(',', '.'); // Thay dấu phẩy bằng dấu chấm
  }

  Future<List<Product>> getProducts (List<String> ListID) async {
    productAPI productService = productAPI();
    List<Product>? products = await productService.getProductsByIds(ListID);
    return products ?? [];
  }


  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
          },
        ),
        title: const Text(
          'CART',
          style:
              TextStyle(fontSize: 25, color: Colors.black, fontFamily: 'Itim'),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              _clearCart();
            },
            child: const Text('CLEAR CART'),
            style: TextButton.styleFrom(
              foregroundColor: Color.fromRGBO(241, 173, 92, 1.0),
            ),
          ),
        ],
      ),
      body: FutureBuilder(future: loadDataDB(), builder: (context, data){
        if(data.connectionState == ConnectionState.waiting){
          return Center(
            child: Container(
              child: const CircularProgressIndicator(color: Colors.orange),
            ),
          );
        }else{
          return RefreshIndicator(
              onRefresh: _refreshItems,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(143, 245, 196, 1.0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_shipping,
                              color: Color.fromRGBO(53, 195, 124, 1.0),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Giao hàng tiết kiệm đến 5%',
                              style: TextStyle(
                                color: Color.fromRGBO(53, 195, 124, 1.0),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'YOUR CART',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.error_outline,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    // get data
                    Container(
                      height: 250, // Chiều cao cố định cho danh sách
                      child: FutureBuilder(
                        future: getProducts(listID),
                        builder: (context, data) {
                          if(data.hasData){
                            listProduct = data.data!;
                          }

                          if (listProduct.isEmpty) {
                            return const Center(
                              child: Text("No Data"),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: listProduct.length,
                              itemBuilder: (context, index) {
                                return _buildCartItem(listProduct[index], 1);
                              },
                            );
                          }
                        },
                      ),
                    ),
                    //voucher
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                           Expanded(
                            child: TextField(
                              controller: code,
                              decoration: const InputDecoration(
                                hintText: 'Nhập mã giảm giá...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (code.text.isEmpty) {
                                _showToast("Chưa nhập mã giảm giá");
                                return;
                              }

                              // Kiểm tra xem mã giảm giá có tồn tại không
                              voucher? selectedVoucher;
                              bool isUsed = false;

                              for (voucher voucherItem in listVouchers) {
                                if (voucherItem.code == code.text) {
                                  if(getTotalPriceNoAsync() >= voucherItem.minOrder){
                                    selectedVoucher = voucherItem;
                                    // Kiểm tra xem mã này đã được sử dụng chưa
                                    isUsed = listVoucherUse.any((voucherUse use) =>
                                    use.voucher_id == voucherItem.voucher_id);
                                  }else{
                                    _showToast("Áp dụng cho hóa đơn từ ${voucherItem.minOrder}");
                                  }

                                  break;
                                }
                              }

                              if (selectedVoucher == null) {
                                _showToast("Code không tồn tại");
                              } else if (isUsed) {
                                _showToast("Code đã sử dụng");
                              } else if (vouchercoding != null) {
                                _showToast("Chỉ có thể sử dụng một mã giảm giá");
                              } else {
                                setState(() {
                                  vouchercoding = selectedVoucher;
                                });
                                _showToast("Ok");
                              }
                            },
                            child: Text('APPLY'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(241, 173, 92, 1.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: CustomPaint(
                        painter: TicketPainter(),
                        child: SizedBox(
                          width: 350,
                          height: 120,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        vouchercoding == null ? "-" : '${vouchercoding!.discount}%',
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontFamily: "Mina",
                                          color: Color.fromRGBO(221, 126, 78, 1.0),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "-min: ${vouchercoding == null ? "-" : '${vouchercoding!.minOrder}'}",
                                        style: const TextStyle(
                                          color: Color.fromRGBO(176, 176, 176, 1.0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Code: ${vouchercoding == null ? "-" : vouchercoding!.code}',
                                    style: const TextStyle(
                                      fontFamily: "Mina",
                                      color: Color.fromRGBO(176, 176, 176, 1.0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                margin: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey, width: 2),
                                ),
                                child: const CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  radius: 30,
                                  child: Image(
                                    image:
                                    AssetImage('assets/Image/logoShopPet 3@2x.png'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${getTotalItems()} Items',
                                  style: const TextStyle(fontSize: 16, fontFamily: "Mina"),
                                ),
                                FutureBuilder(future: getTotalPrice(), builder: (ctx, data){
                                  if(data.connectionState == ConnectionState.waiting){
                                    return const Text(
                                      '0',
                                      style: TextStyle(fontSize: 16, fontFamily: "Mina"),
                                    );
                                  }

                                  return Text(
                                    formatCurrency(data.data!),
                                    style: const TextStyle(fontSize: 16, fontFamily: "Mina"),
                                  );
                                }),

                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'You save',
                                  style: TextStyle(fontSize: 14, fontFamily: "Mina"),
                                ),
                                Text(
                                  '${vouchercoding == null ? "0" : vouchercoding!.discount}%',
                                  style: const TextStyle(fontSize: 14, fontFamily: "Mina"),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.grey[300],
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Price',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),

                                FutureBuilder(future: getTotalPrice(), builder: (context, data){
                                  if(data.connectionState == ConnectionState.waiting) {
                                    return const Text(
                                      '0 VNĐ',
                                      style: TextStyle(color: Colors.red),
                                    );
                                  }

                                  return Text(
                                    '${formatCurrency(data.data! - (data.data! * ((vouchercoding?.discount ?? 0)/100)))} VNĐ', // Giả sử đã áp dụng giảm giá 3%
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  );
                                }),

                              ],
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  if(getTotalItems() >= 1) {
                                    widget.togetherNav();
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            invoiceScreen(
                                              togetherNav: widget.togetherNav,
                                              listProduct: listProduct,
                                              DataAmount: DataAmount,
                                              totalPrice: formatCurrency(getTotalPriceNoAsync() - (getTotalPriceNoAsync()*((vouchercoding?.discount??0)/100))),
                                              vouchercoding: vouchercoding,
                                              totalPriceDouble: getTotalPriceNoAsync() - (getTotalPriceNoAsync()*((vouchercoding?.discount??0)/100)),
                                              clearDataCartScreen: (){
                                                clearData();
                                              },
                                            )));
                                  }else{
                                    _showToast("Mua ít nhất một sản phẩm");
                                  }
                                },
                                child: Text('CHECK OUT'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 100),
                                  backgroundColor: Color.fromRGBO(241, 173, 92, 1.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
          );
        }
      })
    );
  }

  Future<void> _refreshItems() async {
    await Future.delayed(Duration(seconds: 2)); // Mô phỏng thời gian tải lại dữ liệu
    await _loadData();
    setState((){});
  }

  Widget _buildCartItem(Product item, int quality) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Colors.grey),
            ),
            child: item.image == "none" ? Icon(Icons.image_not_supported_outlined, size: 50, color: Colors.grey,) : Image.memory(
                base64ToImage(item.image)
            )
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  utf8.decode(item.name.runes.toList()),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "itim"),
                ),

                Text(
                  '${formatCurrency(item.price * (DataAmount[item.product_id] ?? 1))} VNĐ',
                  style: const TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if(DataAmount[item.product_id]! > 0) {
                      DataAmount[item.product_id] = DataAmount[item.product_id]! - 1;
                      if(getTotalPriceNoAsync() < (vouchercoding?.minOrder ?? 1)){
                        vouchercoding = null;
                      }
                      if (DataAmount[item.product_id]! == 0) {
                        listProduct.remove(item);
                        DataAmount.remove(item.product_id);
                        Slashsceen.cartItemsUser[0].removeWhere((cartitem) {
                          return cartitem.product_ID == item.product_id;
                        });
                        _loadData();
                      }
                    }
                  });
                },
              ),
              Text("${DataAmount[item.product_id]}"),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    DataAmount[item.product_id] = DataAmount[item.product_id]! + 1;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Phần TicketPainter
class TicketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color.fromARGB(50, 222, 215, 215)
      ..style = PaintingStyle.fill;

    var path = Path();
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(10)));

    canvas.drawPath(path, paint);

    var circlePaint = Paint()..color = Colors.grey[50]!;
    canvas.drawCircle(Offset(size.width, size.height / 2), 20, circlePaint);

    var dashPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    const dashWidth = 5;
    const dashSpace = 3;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width * 0.7, startY),
          Offset(size.width * 0.7, startY + dashWidth), dashPaint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
