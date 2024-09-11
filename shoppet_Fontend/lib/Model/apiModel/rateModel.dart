class Rate {
  final String productID;
  final String userID;
  final int rate;
  final String comment;

  Rate({required this.productID, required this.userID, required this.rate, required this.comment});

  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
      productID: json['productID'] as String, // Đổi thành uuid để khớp với JSON
      userID: json['userID'] as String,
      rate: json['rate'] as int,
      comment: json['comment'] as String
    );
  }
}