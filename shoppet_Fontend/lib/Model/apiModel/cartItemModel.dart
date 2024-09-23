class cartItems {
  final String cartItemID;
  final String cartID;
  final String product_ID;
  final String name;
  final int price;
  final String imagePath; // Thêm trường name
  final int quantity;

  cartItems({
    required this.cartItemID,
    required this.cartID,
    required this.product_ID,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.quantity,
  });

  factory cartItems.fromJson(Map<String, dynamic> json) {
    return cartItems(
      cartItemID:
          json['cartItemID'] as String, // Đổi thành uuid để khớp với JSON
      cartID: json['cartID'] as String,
      product_ID: json['product_ID'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      imagePath: json['imagePath'] as String,
      quantity: json['quantity'] as int,
    );
  }
}
