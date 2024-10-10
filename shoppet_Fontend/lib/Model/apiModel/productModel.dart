import 'dart:io';

class Product {
  final String product_id; // UUID của sản phẩm
  final String name;
  final String description;
  final double price;
  final int stock_quantity;
  final String category_id; // ID của danh mục
  final String create_at; // Ngày tạo
  final String image;
  File? imageFile; // Có thể null, không bắt buộc

  // Constructor
  Product({
    this.imageFile, // Có thể truyền hoặc không
    required this.product_id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock_quantity,
    required this.category_id,
    required this.create_at,
    required this.image,
  });

  // Phương thức factory để tạo đối tượng từ JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_id: json['product_id'] as String, // ID sản phẩm (UUID)
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      stock_quantity: json['stock_quantity'] as int,
      category_id: json['category_id'] as String,
      create_at: json['created_at'] as String,
      image: json['image'] as String,
      // imageFile không có trong JSON, giữ nguyên là null khi tạo từ JSON
    );
  }
}
