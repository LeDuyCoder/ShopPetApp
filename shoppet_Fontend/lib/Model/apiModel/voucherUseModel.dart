class voucherUse {
  final String userId;
  final String voucher_id;

  voucherUse({required this.userId, required this.voucher_id});

  factory voucherUse.fromJson(Map<String, dynamic> json) {
    return voucherUse(
      userId: json['userId'] as String, // Đổi thành uuid để khớp với JSON
      voucher_id: json['voucher_id'] as String,
    );
  }
}