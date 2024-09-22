import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppet_fontend/API/Server/cartItemAPI.dart';
import 'package:shoppet_fontend/Model/apiModel/cartItemModel.dart';

class CartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> {
  List<cartItems> CartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  void _fetchCartItems() async {
    List<cartItems>? items = await cartItemAPI().getCartItems();
    setState(() {
      CartItems = items ?? []; // cập nhật giỏ hàng
    });
  }

  void _clearCart() {
    setState(() {
      CartItems.clear();
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
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _clearCart,
            child: const Text('CLEAR CART'),
            style: TextButton.styleFrom(
              foregroundColor: Color.fromRGBO(241, 173, 92, 1.0),
            ),
          ),
        ],
      ),
      body: Column(
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
          // Phần "YOUR CART"
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'YOUR CART',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4), // Khoảng cách giữa chữ "YOUR CART" và icon
                Icon(
                  Icons.error_outline, // Icon chấm than
                  color: Colors.grey, // Màu của icon
                  size: 20, // Kích thước của icon
                ),
              ],
            ),
          ),

          //  get data from _buildCartItem(item)
          Expanded(
            child: ListView.builder(
              itemCount: CartItems.length,
              itemBuilder: (context, index) {
                final item = CartItems[index];
                return _buildCartItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(cartItems item) {
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
            child: Image.asset(
              item.imagePath, // Sử dụng đường dẫn hình ảnh từ item
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
              width: 16), // Khoảng cách giữa hình ảnh và thông tin sản phẩm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name, // Hiển thị tên sản phẩm từ item
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${item.price} VNĐ', // Hiển thị giá sản phẩm từ item
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  // Giảm số lượng
                },
              ),
              Text(item.quantity.toString()), // Hiển thị số lượng sản phẩm
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // Tăng số lượng
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
