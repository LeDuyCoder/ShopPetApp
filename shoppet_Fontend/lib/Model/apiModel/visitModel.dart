class Visit {
  final String userID; // Thay đổi thành userId để khớp với uuid
  final String date;

  Visit({required this.userID, required this.date});

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      userID: json['userID'] as String, // Đổi thành uuid để khớp với JSON
      date: json['date'] as String,
    );
  }


}