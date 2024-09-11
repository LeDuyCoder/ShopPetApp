class User {
  final String userId; // Thay đổi thành userId để khớp với uuid
  final String username;
  final String password;
  final String mail;
  final String name;
  final int phone; // Đảm bảo phone là int
  final String createdAt; // Thay đổi thành createdAt để khớp với create_at
  final String role;

  User({
    required this.userId,
    required this.username,
    required this.password,
    required this.mail,
    required this.name,
    required this.phone,
    required this.createdAt,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['uuid'] as String, // Đổi thành uuid để khớp với JSON
      username: json['username'] as String,
      password: json['password'] as String,
      mail: json['mail'] as String,
      name: json['name'] as String,
      phone: json['phone'] as int, // Đảm bảo phone là int
      createdAt: json['create_at'] as String, // Đổi thành create_at để khớp với JSON
      role: json['role'] as String,
    );
  }

  // Chuyển đối tượng User thành JSON
  Map<String, dynamic> toJson() {
    return {
      'uuid': userId, // Đổi lại thành uuid để khớp với định dạng JSON
      'username': username,
      'password': password,
      'mail': mail,
      'name': name,
      'phone': phone,
      'create_at': createdAt, // Đổi lại thành create_at để khớp với định dạng JSON
      'role': role,
    };
  }
}
