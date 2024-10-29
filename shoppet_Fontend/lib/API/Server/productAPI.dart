import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:shoppet_fontend/Model/apiModel/productModel.dart';

import '../Local/config.dart';
import 'package:http/http.dart' as http;




class productAPI{

  String apiUrl = config.apiUrl;


  /// Lấy danh sách sản phẩm từ API.
  ///
  /// **Trả về:**
  /// - Một danh sách `Product` nếu thành công hoặc `null` nếu không có sản phẩm nào.
  ///
  /// **Lưu ý:**
  /// - Hàm này không yêu cầu tham số đầu vào.
  Future<List<Product>?> getProducts() async {
    try{
      final response = await http.get(
          Uri.parse('$apiUrl/api/getProduct'));

      if(response.statusCode == 204){
        return null;
      }else if(response.statusCode == 200) {
        List<dynamic> jsonResponse;
        if (response.headers['content-type']?.contains('charset=utf-8') ??
            false) {
          jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        } else {
          jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        }

        List<Product> products = [];
        jsonResponse.forEach((product) {
          Product product_output = Product.fromJson(
              product as Map<String, dynamic>);
          products.add(product_output);
        });

        return products;
      }
    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Lấy sản phẩm dựa trên [productId].
  ///
  /// Nếu không truyền vào [productId], giá trị mặc định là `"none"`.
  ///
  /// **Tham số:**
  /// - [productId]: ID của sản phẩm cần lấy thông tin. Nếu không cung cấp, mặc định là `"none"`.
  ///
  /// **Trả về:**
  /// - Một danh sách `Product` nếu thành công hoặc `null` nếu không có sản phẩm nào.
  ///
  /// **Lưu ý:**
  /// - Đảm bảo rằng `productId` không phải là `"none"` khi gọi hàm để tránh lỗi.
  Future<List<Product>?> getProductById(String productId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/getProduct?product_id=$productId&name=none&category_id=none'));

      if (response.statusCode == 204) {
        return null;
      } else if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        List<Product> products = [];
        jsonResponse.forEach((product) {
          Product product_output = Product.fromJson(product as Map<String, dynamic>);
          products.add(product_output);
        });
        return products;
      }
    } catch (e) {
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Lấy sản phẩm dựa trên [name].
  ///
  /// Nếu không truyền vào [name], giá trị mặc định là `"none"`.
  ///
  /// **Tham số:**
  /// - [name]: Tên của sản phẩm cần lấy thông tin. Nếu không cung cấp, mặc định là `"none"`.
  ///
  /// **Trả về:**
  /// - Một danh sách `Product` nếu thành công hoặc `null` nếu không có sản phẩm nào.
  ///
  /// **Lưu ý:**
  /// - Đảm bảo rằng `name` không phải là `"none"` khi gọi hàm để tránh lỗi.
  Future<List<Product>?> getProductByName(String name) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/getProduct?product_id=none&name=$name&category_id=none'));

      if (response.statusCode == 204) {
        return null;
      } else if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        List<Product> products = [];
        jsonResponse.forEach((product) {
          Product product_output = Product.fromJson(product as Map<String, dynamic>);
          products.add(product_output);
        });
        return products;
      }
    } catch (e) {
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Lấy danh sách sản phẩm từ API dựa trên danh sách ID sản phẩm.
  ///
  /// **Tham số:**
  /// - `productIds`: Danh sách ID của các sản phẩm cần truy vấn.
  ///
  /// **Trả về:**
  /// - Một danh sách `Product` nếu thành công hoặc `null` nếu không có sản phẩm nào.
  ///
  /// **Lưu ý:**
  /// - Hàm này yêu cầu tham số là một danh sách `ID`.
  Future<List<Product>?> getProductsByIds(List<String> productIds) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/getProductsByIds'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(productIds), // Chuyển danh sách ID thành JSON để gửi lên API
      );

      if (response.statusCode == 204) {
        return null; // Trả về null nếu không có sản phẩm nào
      } else if (response.statusCode == 200) {
        List<dynamic> jsonResponse;

        if (response.headers['content-type']?.contains('charset=utf-8') ?? false) {
          jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        } else {
          jsonResponse = json.decode(response.body);
        }

        // Chuyển đổi JSON thành danh sách sản phẩm
        List<Product> products = jsonResponse
            .map((product) => Product.fromJson(product as Map<String, dynamic>))
            .toList();

        return products; // Trả về danh sách sản phẩm
      } else {
        throw Exception("Failed to load products"); // Trả về lỗi nếu không thành công
      }
    } catch (e) {
      throw Exception(config.ERROR_SERVER); // Xử lý lỗi kết nối server
    }
  }


  /// Lấy sản phẩm dựa trên [name].
  ///
  /// Nếu không truyền vào [name], giá trị mặc định là `"none"`.
  ///
  /// **Tham số:**
  /// - [name]: Tên của sản phẩm cần lấy thông tin. Nếu không cung cấp, mặc định là `"none"`.
  ///
  /// **Trả về:**
  /// - Một danh sách `Product` nếu thành công hoặc `null` nếu không có sản phẩm nào.
  ///
  /// **Lưu ý:**
  /// - Đảm bảo rằng `name` không phải là `"none"` khi gọi hàm để tránh lỗi.
  Future<List<Product>?> searchProductByName(String name) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/searchProduct?name=$name'));

      if (response.statusCode == 204) {
        return null;
      } else if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        List<Product> products = [];
        for (var product in jsonResponse) {
          Product productOutput = Product.fromJson(product as Map<String, dynamic>);
          products.add(productOutput);
        }
        return products;
      }else{
        return null;
      }
    } catch (e) {
      throw Exception(config.ERROR_SERVER);
    }
    return null;
  }

  /// Lấy sản phẩm dựa trên [categoryId].
  ///
  /// Nếu không truyền vào [categoryId], giá trị mặc định là `"none"`.
  ///
  /// **Tham số:**
  /// - [categoryId]: ID của danh mục sản phẩm cần lấy thông tin. Nếu không cung cấp, mặc định là `"none"`.
  ///
  /// **Trả về:**
  /// - Một danh sách `Product` nếu thành công hoặc `null` nếu không có sản phẩm nào.
  ///
  /// **Lưu ý:**
  /// - Đảm bảo rằng `categoryId` không phải là `"none"` khi gọi hàm để tránh lỗi.
  Future<List<Product>?> getProductByCategoryId(String categoryId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/getProduct?product_id=none&name=none&category_id=$categoryId'));

      if (response.statusCode == 204) {
        return null;
      } else if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        List<Product> products = [];
        jsonResponse.forEach((product) {
          Product product_output = Product.fromJson(product as Map<String, dynamic>);
          products.add(product_output);
        });
        return products;
      }
    } catch (e) {
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Tạo sản phẩm mới dựa trên các tham số đầu vào.
  ///
  /// **Tham số:**
  /// - [name]: Tên sản phẩm cần tạo.
  /// - [description]: Mô tả chi tiết về sản phẩm.
  /// - [price]: Giá của sản phẩm.
  /// - [stock_quantity]: Số lượng tồn kho của sản phẩm.
  /// - [category_id]: ID của danh mục mà sản phẩm thuộc về.
  /// - [image]: URL hoặc đường dẫn hình ảnh của sản phẩm, mặc định là `"none"`.
  ///
  /// **Trả về:**
  /// - `CreateProductStatus.created` nếu sản phẩm được tạo thành công.
  /// - `CreateProductStatus.conflict` nếu tên sản phẩm đã tồn tại.
  /// - `CreateProductStatus.error` nếu có lỗi xảy ra trong quá trình tạo sản phẩm.
  ///
  /// **Lưu ý:**
  /// - Đảm bảo rằng tất cả các tham số bắt buộc đều được cung cấp và hợp lệ.
  /// - Kiểm tra trạng thái trả về để xử lý các tình huống như tên sản phẩm trùng lặp hoặc lỗi máy chủ.
  Future<HTTPReult> createProduce({
    required String name,
    required String description,
    required double price,
    required int stock_quantity,
    required String category_id,
    File? image, // Sửa kiểu dữ liệu của image thành File?
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/api/createProduct'));

      // Thêm các field vào request
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();
      request.fields['stock_quantity'] = stock_quantity.toString();
      request.fields['category_id'] = category_id;

      // Nếu có file ảnh, thêm vào multipart request
      if (image != null) {
        var stream = http.ByteStream(image.openRead());
        var length = await image.length(); // Lấy độ dài của file

        // Tạo đối tượng MultipartFile và thêm vào request
        var multipartFile = http.MultipartFile(
          'image', // Tên field cho file ảnh
          stream,
          length,
          filename: "product_image", // Tên file (tùy chỉnh)
        );

        request.files.add(multipartFile); // Thêm file vào request
      }

      // Gửi request
      var response = await request.send();

      // Xử lý phản hồi
      if (response.statusCode == 201) {
        return HTTPReult.created;
      } else if (response.statusCode == 409) {
        return HTTPReult.conflict;
      } else {
        return HTTPReult.error;
      }
    } catch (e) {
      throw Exception(config.ERROR_SERVER);
    }
  }


  /// Cập nhật thông tin sản phẩm dựa trên các tham số đầu vào.
  ///
  /// **Tham số:**
  /// - [produceID]: ID của sản phẩm cần cập nhật. Đây là tham số bắt buộc.
  /// - [name]: Tên sản phẩm mới, mặc định là `"none"`. Nếu không có thay đổi, giữ giá trị mặc định.
  /// - [description]: Mô tả mới của sản phẩm, mặc định là `"none"`. Nếu không có thay đổi, giữ giá trị mặc định.
  /// - [price]: Giá mới của sản phẩm, mặc định là `0.0`. Nếu không có thay đổi, giữ giá trị mặc định.
  /// - [stock_quantity]: Số lượng tồn kho mới, mặc định là `0`. Nếu không có thay đổi, giữ giá trị mặc định.
  /// - [category_id]: ID danh mục mới của sản phẩm, mặc định là `"none"`. Nếu không có thay đổi, giữ giá trị mặc định.
  /// - [image]: URL hoặc đường dẫn hình ảnh mới của sản phẩm, mặc định là `"none"`. Nếu không có thay đổi, giữ giá trị mặc định.
  ///
  /// **Trả về:**
  /// - `HTTPReult.ok` nếu cập nhật thành công.
  /// - `HTTPReult.nofound` nếu sản phẩm không tồn tại.
  /// - `HTTPReult.error` nếu có lỗi xảy ra trong quá trình cập nhật.
  ///
  /// **Lưu ý:**
  /// - Đảm bảo rằng [productID] là giá trị hợp lệ và tồn tại.
  /// - Các tham số tùy chọn khác có thể được để mặc định nếu không có thay đổi tương ứng.
  /// - Kiểm tra trạng thái trả về để xử lý các tình huống như sản phẩm không tồn tại hoặc lỗi máy chủ.
  Future<HTTPReult> updateProduct({
    required String productID,
    String name = "none",
    String description = "none",
    double price = 0,
    int stock_quantity = 0,
    String category_id = "none",
    String image="none",
  }) async {

    List<Product>? produces = await getProductById(productID);
    if(produces != null) {
      if (!produces.isEmpty) {
        final response = await http.put(Uri.parse(
            '$apiUrl/api/updateProduct?product_id=$productID&name=$name&description=$description&price=$price&stock_quantity=$stock_quantity&category_id=$category_id&image=$image'));

        if(response.statusCode == 200){
          return HTTPReult.ok;
        }else if(response.statusCode == 404){
          return HTTPReult.nofound;
        }else{
          return HTTPReult.error;
        }
      } else {
        return HTTPReult.error;
      }
    }else{
      return HTTPReult.nofound;
    }
  }

  /// Xóa một sản phẩm khỏi hệ thống dựa trên [productID].
  ///
  /// **Tham số:**
  /// - [productID]: ID của sản phẩm cần xóa. Đây là tham số bắt buộc.
  ///
  /// **Trả về:**
  /// - `HTTPReult.ok` nếu xóa sản phẩm thành công.
  /// - `HTTPReult.nofound` nếu sản phẩm không tồn tại.
  /// - `HTTPReult.error` nếu có lỗi xảy ra trong quá trình xóa.
  ///
  /// **Lưu ý:**
  /// - Đảm bảo rằng [productID] là giá trị hợp lệ và tồn tại trong hệ thống.
  /// - Kiểm tra trạng thái trả về để xử lý các tình huống như sản phẩm không tồn tại hoặc lỗi máy chủ.
  Future<HTTPReult> removeProduct({required String productID}) async {
    final response = await http.delete(Uri.parse(
        '$apiUrl/api/removeProduct?product_id=$productID'));
    if(response.statusCode == 200){
      return HTTPReult.ok;
    }else if(response.statusCode == 404){
      return HTTPReult.nofound;
    }else{
      return HTTPReult.error;
    }
  }


}