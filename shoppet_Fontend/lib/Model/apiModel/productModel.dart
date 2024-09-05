class Product {
  final String product_id; // Thay đổi thành userId để khớp với uuid
  final String name;
  final String description;
  final double price;
  final int stock_quantity;
  final String category_id; // Đảm bảo phone là int
  final String create_at; // Thay đổi thành createdAt để khớp với create_at
  final String image;

  Product({required this.product_id, required this.name, required this.description, required this.price,
      required this.stock_quantity, required this.category_id, required this.create_at, required this.image});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_id: json['product_id'] as String, // Đổi thành uuid để khớp với JSON
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      stock_quantity: json['stock_quantity'] as int,
      category_id: json['category_id'] as String, // Đảm bảo phone là int
      create_at: json['created_at'] as String, // Đổi thành create_at để khớp với JSON
      image: json['image'] as String,
    );
  }
}