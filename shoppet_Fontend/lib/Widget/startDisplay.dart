import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarDisplay extends StatelessWidget {
  final double value; // Số sao để hiển thị (có thể là số lẻ như 4.5)
  final int starCount; // Tổng số sao (thường là 5)
  final double size;

  StarDisplay ({required this.size, this.value = 0.0, this.starCount = 5});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        // Tính toán loại biểu tượng để hiển thị (sao đầy, nửa hoặc rỗng)
        if (index < value.floor()) {
          return Icon(Icons.star, color: Colors.amber, size: size,); // Sao đầy
        } else if (index < value && index + 1 > value) {
          return Icon(Icons.star_half, color: Colors.amber, size: size,); // Sao nửa
        } else {
          return Icon(Icons.star_border, color: Colors.amber, size: size,); // Sao rỗng
        }
      }),
    );
  }
}

class StarDisplayApp extends StatelessWidget {
  final double value;
  final double size;

  StarDisplayApp({super.key, required this.value, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return StarDisplay(
      size: size,
      value: value, // Giá trị này quyết định số sao được tô đầy, nửa và rỗng
    );
  }
}