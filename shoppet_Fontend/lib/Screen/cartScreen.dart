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

  int getTotalItems() {
    return CartItems.fold(0, (total, item) => total + item.quantity);
  }

  double getTotalPrice() {
    return CartItems.fold(
        0.0, (total, item) => total + (item.price * item.quantity));
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
          Expanded(
            child: ListView.builder(
              itemCount: CartItems.length,
              itemBuilder: (context, index) {
                final item = CartItems[index];
                return _buildCartItem(item);
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
                    decoration: InputDecoration(
                      hintText: 'Nhập mã giảm giá...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Xử lý mã giảm giá
                  },
                  child: Text('APPLY'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(241, 173, 92, 1.0),
                  ),
                ),
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "3%",
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: "Mina",
                                color: Color.fromRGBO(221, 126, 78, 1.0),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "-min: 1.000.000",
                              style: TextStyle(
                                color: Color.fromRGBO(176, 176, 176, 1.0),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Code: Le29',
                          style: TextStyle(
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
                        style: TextStyle(fontSize: 16, fontFamily: "Mina"),
                      ),
                      Text(
                        '${getTotalPrice()} VNĐ',
                        style: TextStyle(fontSize: 16, fontFamily: "Mina"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You save',
                        style: TextStyle(fontSize: 14, fontFamily: "Mina"),
                      ),
                      Text(
                        '3%',
                        style: TextStyle(fontSize: 14, fontFamily: "Mina"),
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
                      Text(
                        'Total Price',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${getTotalPrice() * 0.97} VNĐ', // Giả sử đã áp dụng giảm giá 3%
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Xử lý thanh toán
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
              item.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.name}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${item.price} VNĐ',
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
              Text(item.quantity.toString()),
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
