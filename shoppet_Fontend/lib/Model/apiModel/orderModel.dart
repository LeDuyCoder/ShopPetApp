class Orders {
  final String order_id;
  final String user_id;
  final double total_price;
  final String status;
  final String created_at;
  final List<String> voucher_id;

  Orders({required this.order_id, required this.user_id, required this.total_price, required this.status, required this.created_at, required this.voucher_id});

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      order_id: json['order_id'] as String,
      user_id: json['user_id'] as String,
      total_price: double.parse(json['total_price'] as String),
      status: json['status'] as String,
      created_at: json['created_at'] as String,
      voucher_id: json['voucher_id'] == null? <String>[] : json['voucher_id'] as List<String>,
    );
  }

}