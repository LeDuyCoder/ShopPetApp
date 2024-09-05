class Cart {
  final String cart_id;
  final String user_id;
  final String created_at;

  Cart({required this.cart_id, required this.user_id, required this.created_at});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cart_id: json['cart_id'] as String, // Đổi thành uuid để khớp với JSON
      user_id: json['user_id'] as String,
      created_at: json['created_at'] as String,
    );
  }
}