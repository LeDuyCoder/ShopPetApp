class cartItems {
  final String cartItemID;
  final String cartID;
  final String product_ID;

  cartItems({required this.cartItemID, required this.cartID, required this.product_ID});

  factory cartItems.fromJson(Map<String, dynamic> json) {
    return cartItems(
      cartItemID: json['cartItemID'] as String, // Đổi thành uuid để khớp với JSON
      cartID: json['cartID'] as String,
      product_ID: json['product_ID'] as String,
    );
  }
}