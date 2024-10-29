import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shoppet_fontend/Model/apiModel/orderItemModel.dart';

import '../Local/config.dart';

class orderItemAPI{
  String apiUrl = config.apiUrl;

  /// Lấy danh sách tất cả các order items từ server.
  ///
  /// Hàm này gửi yêu cầu GET đến API tại đường dẫn `$apiUrl/api/getOrderItems`.
  /// Nếu yêu cầu thành công, nó sẽ nhận về danh sách các order items từ server.
  ///
  /// Kết quả trả về là một danh sách các đối tượng [orderItems].
  ///
  /// Trả về `null` nếu yêu cầu không thành công (tức là mã trạng thái HTTP khác 200).
  ///
  /// Ném [Exception] nếu gặp lỗi server hoặc lỗi kết nối.
  ///
  Future<List<orderItems>?> getOrderItems() async {
    try{
      final response = await http.get(Uri.parse('$apiUrl/api/getOrderItems'));
      if(response.statusCode == 200){
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        List<orderItems> listOrderItems = [];
        jsonResponse.forEach((item){
          listOrderItems.add(orderItems.fromJson(item));
        });

        return listOrderItems;
      }else{
        return null;
      }
    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Lấy danh sách các order items dựa trên `orderID` từ server.
  ///
  /// Hàm này gửi yêu cầu GET đến API tại đường dẫn `$apiUrl/api/getOrderItems?order_id=$orderID`.
  /// Nếu yêu cầu thành công, nó sẽ nhận về danh sách các order items có liên quan đến `orderID` từ server.
  ///
  /// [orderID] là ID của order cần lấy thông tin các items.
  ///
  /// Kết quả trả về là một danh sách các đối tượng [orderItems].
  ///
  /// Trả về `null` nếu yêu cầu không thành công (tức là mã trạng thái HTTP khác 200).
  ///
  /// Ném [Exception] nếu gặp lỗi server hoặc lỗi kết nối.
  ///
  /// Ví dụ sử dụng:
  ///
  /// ```dart
  /// String orderID = "04bc09ea-9352-4a2d-8c81-02278f2450f8";
  /// List<orderItems>? items = await getOrderItemsbyOrderID(orderID: orderID);
  /// if (items != null) {
  ///   // Xử lý danh sách order items cho order cụ thể
  /// } else {
  ///   // Xử lý khi không lấy được dữ liệu
  /// }
  Future<List<orderItems>?> getOrderItemsbyOrderID({required String orderID}) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/getOrderItems?order_id=$orderID'));

      if(response.statusCode == 200){
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        List<orderItems> listOrderItems = [];
        jsonResponse.forEach((item){
          listOrderItems.add(orderItems.fromJson(item));
        });

        return listOrderItems;
      }else{
        return null;
      }

    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Gửi yêu cầu tạo một order mới với các order items tới server.
  ///
  /// Hàm này gửi yêu cầu POST đến API tại đường dẫn `$apiUrl/api/addItems`.
  /// Dữ liệu được gửi trong body dưới dạng JSON chứa danh sách các order items.
  ///
  /// Mỗi order item trong danh sách bao gồm các thông tin sau:
  /// - `orderItemID`: ID của order item (kiểu `String`).
  /// - `orderID`: ID của order (kiểu `String`).
  /// - `productID`: ID của sản phẩm (kiểu `String`).
  /// - `quantity`: Số lượng của sản phẩm trong order (kiểu `int`).
  /// - `price`: Giá của sản phẩm (kiểu `double`).
  ///
  /// [orderItems] là danh sách các order items cần được thêm vào order.
  ///
  /// Trả về [HTTPReult.ok] nếu yêu cầu thành công (mã trạng thái HTTP 201).
  /// Nếu yêu cầu thất bại, trả về [HTTPReult.error] và in ra mã trạng thái.
  ///
  /// Ném [Exception] nếu gặp lỗi server hoặc lỗi kết nối.
  ///
  /// ```dart
  /// List<Map<String, dynamic>> orderItems = [
  ///   {
  ///     "orderItemID": "24bcef8a-2f7c-6f9e-64ca-c2c49e6aef15",
  ///     "orderID": "04bc09ea-9352-4a2d-8c81-02278f2450f8",
  ///     "productID": "24bdbf8a-0f7e-3f9e-85ca-c2c49e6aef15",
  ///     "quantity": 2,
  ///     "price": 40000
  ///   }
  /// ];
  ///
  /// HTTPReult result = await createOrderWithItems(orderItems);
  /// ```
  ///
  /// Kết quả trả về [HTTPReult.ok] nếu tạo thành công, [HTTPReult.error] nếu tạo thất bại.
  Future<HTTPReult> createOrderWithItems(List<Map<String, dynamic>> orderItems) async {
    try {
      // Tạo một map để lưu các sản phẩm đã gộp
      Map<String, Map<String, dynamic>> groupedItems = {};

      for (var item in orderItems) {
        String productId = item['productID'];
        String orderId = item['orderID'];

        String key = '$orderId-$productId';

        if (groupedItems.containsKey(key)) {
          groupedItems[key]!['quantity'] += item['quantity'];
          groupedItems[key]!['price'] += item['price'];
        } else {
          groupedItems[key] = Map<String, dynamic>.from(item);
        }
      }

      // Chuyển các sản phẩm đã gộp thành một danh sách
      List<Map<String, dynamic>> mergedOrderItems = groupedItems.values.toList();

      // Convert the merged orderItems list to JSON
      String body = json.encode(mergedOrderItems);

      // Send the POST request
      final response = await http.post(
        Uri.parse('$apiUrl/api/addItems'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if(response.statusCode == 201){
        return HTTPReult.ok;
      } else {
        return HTTPReult.error;
      }

    } catch(e) {
      throw Exception(config.ERROR_SERVER);
    }
  }


  /// Xóa một order item dựa trên `orderID` từ server.
  ///
  /// Hàm này gửi yêu cầu DELETE đến API tại đường dẫn `$apiUrl/api/removeItems?order_id=$orderID`.
  /// Nếu yêu cầu thành công và item được xóa, hàm sẽ trả về [HTTPReult.ok].
  /// Nếu không tìm thấy order với `orderID` đã cung cấp, hàm sẽ trả về [HTTPReult.nofound].
  /// Nếu có lỗi khác xảy ra, hàm sẽ trả về [HTTPReult.error].
  ///
  /// [orderID] là ID của order item cần xóa.
  ///
  /// Kết quả trả về là một đối tượng [HTTPReult] tương ứng với trạng thái của yêu cầu:
  /// - [HTTPReult.ok]: Khi item được xóa thành công.
  /// - [HTTPReult.nofound]: Khi không tìm thấy order với ID đã cung cấp.
  /// - [HTTPReult.error]: Khi xảy ra lỗi không xác định.
  Future<HTTPReult> removeOrderItem({required String orderID}) async {
    final response = await http.delete(Uri.parse('$apiUrl/api/removeItems?order_id=$orderID'));

    if(response.statusCode == 200){
      return HTTPReult.ok;
    }else if(response.statusCode == 409){
      return HTTPReult.nofound;
    }else{
      return HTTPReult.error;
    }
  }
}