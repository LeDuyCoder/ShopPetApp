class Adminlog{
  final String logID;
  final String adminID;
  final String action;
  final String timestamp;

  Adminlog({required this.logID, required this.adminID, required this.action, required this.timestamp});

  factory Adminlog.fromJson(Map<String, dynamic> json) {
    return Adminlog(
      logID: json['log_id'] as String, // Đổi thành uuid để khớp với JSON
      adminID: json['admin_id'] as String,
      action: json['action'] as String,
      timestamp: json['timestamp'] as String,
    );
  }
}