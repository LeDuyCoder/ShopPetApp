import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppet_fontend/API/Server/cartItemAPI.dart';
import 'package:shoppet_fontend/Model/apiModel/cartItemModel.dart';

class cartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _cartScreen();
}

class _cartScreen extends State<cartScreen> {
  List<cartItems> cartItemsList = [];
  @override
  void initState() {
    super.initState();
    fetchCartItems(); // Lấy dữ liệu từ API khi khởi tạo màn hình
  }

  // Gọi API để lấy danh sách sản phẩm trong giỏ hàng
  void fetchCartItems() async {
    cartItemAPI api = cartItemAPI();
    List<cartItems>? items =
        await api.getCartItemsbyCartID(cartID: "your_cart_id_here");

    if (items != null) {
      setState(() {
        cartItemsList = items;
      });
    } else {
      // Xử lý trường hợp lỗi hoặc không có sản phẩm nào
      print("Failed to load cart items");
    }
  }

  // Hàm cập nhật số lượng sản phẩm
  void updateQuantity(int index, int change) {
    setState(() {});
  }

  // Hàm xóa toàn bộ giỏ hàng
  void clearCart() {
    setState(() {
      cartItemsList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
        title: const Text(
          'CART',
          style:
              TextStyle(fontSize: 25, color: Colors.black, fontFamily: 'Itim'),
        ),
        centerTitle: true, // Center "CART"
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('CLEAR CART'),
            style: TextButton.styleFrom(
              foregroundColor:
                  Color.fromRGBO(241, 173, 92, 1.0), // Màu chữ của "CLEAR CART"
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Color.fromRGBO(143, 245, 196, 1.0), // Màu nền xanh lá nhạt
            borderRadius: BorderRadius.circular(12), // Góc bo tròn
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_shipping, // Biểu tượng giao hàng
                color: Color.fromRGBO(53, 195, 124, 1.0), // Màu biểu tượng
                size: 20,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Giao hàng tiết kiệm đến 5%',
                style: TextStyle(
                  color: Color.fromRGBO(53, 195, 124, 1.0), // Màu chữ
                  fontSize: 16, // Cỡ chữ
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
