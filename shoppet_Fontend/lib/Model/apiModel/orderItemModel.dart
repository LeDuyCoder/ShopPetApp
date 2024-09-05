class orderItems {
  final String orderItemID;
  final String orderID;
  final String productID;
  final int quantity;
  final double price;

  orderItems({required this.orderItemID, required this.orderID, required this.productID, required this.quantity, required this.price});

  factory orderItems.fromJson(Map<String, dynamic> json) {
    return orderItems(
      orderItemID: json['orderItemID'] as String, // Đổi thành uuid để khớp với JSON
      orderID: json['orderID'] as String,
      productID: json['productID'] as String,
      quantity: json['quantity'] as int,
      price: json['price'] as double,
    );
  }
}