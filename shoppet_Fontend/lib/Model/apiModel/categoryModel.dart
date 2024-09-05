class Category {
  final String category_id;
  final String name;
  final String parent_id;

  Category({required this.category_id, required this.name, required this.parent_id});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      category_id: json['category_id'] as String, // Đổi thành uuid để khớp với JSON
      name: json['name'] as String,
      parent_id: json['parent_id'] == null?"null":json['parent_id'] as String,
    );
  }
}