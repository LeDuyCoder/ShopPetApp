class voucher {
  final String voucher_id;
  final String code;
  final double discount;
  final String expiryDate;
  final double minOrder;

  voucher({required this.voucher_id, required this.code, required this.discount, required this.expiryDate, required this.minOrder});

  factory voucher.fromJson(Map<String, dynamic> json) {
    return voucher(
      voucher_id: json['voucher_id'] as String,
      code: json['code'] as String,
      discount: json['discount'] as double,
      expiryDate: json['expiryDate'] as String,
      minOrder: json['minOrder'] as double
    );
  }

}