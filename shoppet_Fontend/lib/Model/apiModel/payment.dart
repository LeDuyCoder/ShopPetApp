import 'dart:ffi';

class payment {
  final String payment_id;
  final String order_id;
  final String payment_method;
  final bool status;
  final String created_at;

  payment({required this.payment_id, required this.order_id, required this.payment_method, required this.status, required this.created_at});

  factory payment.fromJson(Map<String, dynamic> json) {
    return payment(
      payment_id: json['payment_id'] as String,
      order_id: json['order_id'] as String,
      payment_method: json['payment_method'] as String,
      status: json['status'],
      created_at: json['created_at'] as String,
    );
  }

}