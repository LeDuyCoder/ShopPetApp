import 'dart:convert';
import '../../Model/apiModel/orderModel.dart';
import '../Local/config.dart';
import 'package:http/http.dart' as http;

class orderAPI {
  String apiUrl = config.apiUrl;

  /// Lấy danh sách tất cả các đơn hàng từ API.
  ///
  /// Trả về: Một danh sách các đối tượng `Orders` nếu thành công, hoặc `null` nếu không thành công.
  ///
  /// Ví dụ:
  /// ```dart
  /// final orders = await orderAPI.getOrders();
  /// ```
  Future<List<Orders>?> getOrders() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/getOrders'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        List<Orders> listOrders = [];
        jsonResponse.forEach((item) {
          listOrders.add(Orders.fromJson(item));
        });

        return listOrders;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Lấy danh sách đơn hàng theo ID đơn hàng từ API.
  ///
  /// [orderID] là ID của đơn hàng cần lấy.
  ///
  /// Trả về: Một danh sách các đối tượng `Orders` nếu thành công, hoặc `null` nếu không thành công.
  ///
  /// Ví dụ:
  /// ```dart
  /// final orders = await orderAPI.getOrdersbyID(orderID: '123');
  /// ```
  Future<List<Orders>?> getOrdersbyID({required String orderID}) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/getOrders?order_id=$orderID'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        List<Orders> listOrders = [];
        jsonResponse.forEach((item) {
          listOrders.add(Orders.fromJson(item));
        });

        return listOrders;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Lấy danh sách đơn hàng của một người dùng dựa trên ID người dùng từ API.
  ///
  /// [userID] là ID của người dùng cần lấy đơn hàng.
  ///
  /// Trả về: Một danh sách các đối tượng `Orders` nếu thành công, hoặc `null` nếu không thành công.
  ///
  /// Ví dụ:
  /// ```dart
  /// final orders = await orderAPI.getOrdersbyUserID(userID: '456');
  /// ```
  Future<List<Orders>?> getOrdersbyUserID({required String userID}) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/getOrders?user_id=$userID'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        List<Orders> listOrders = [];
        jsonResponse.forEach((item) {
          listOrders.add(Orders.fromJson(item));
        });

        return listOrders;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Tạo một đơn hàng mới cho người dùng.
  ///
  /// [userID] là ID của người dùng thực hiện đơn hàng mới.
  ///
  /// Trả về: Một giá trị của enum `HTTPReult` cho biết kết quả của yêu cầu.
  /// - `HTTPReult.ok` nếu thành công.
  /// - `HTTPReult.error` nếu có lỗi xảy ra.
  ///
  /// Ví dụ:
  /// ```dart
  /// final result = await orderAPI.createOrder(userID: '456');
  /// ```
  Future<String> createOrder({
    required String userID,
    String? voucherID, // Tham số tùy chọn cho voucher_id
  }) async {
    // Xây dựng URL với các tham số thích hợp
    final uri = Uri.parse(
      '$apiUrl/api/createOrder?user_id=$userID${voucherID != null ? '&voucher_id=$voucherID' : ''}',
    );

    // Gửi yêu cầu POST
    final response = await http.post(uri);

    if (response.statusCode == 201) {
      // Trả về UUID từ phản hồi nếu thành công
      return response.body; // Giả định rằng phản hồi là UUID
    } else {
      // Trả về một thông điệp lỗi hoặc giá trị mặc định nếu thất bại
      return 'Error: ${response.statusCode}';
    }
  }



  /// Cập nhật trạng thái của một đơn hàng.
  ///
  /// [orderID] là ID của đơn hàng cần cập nhật.
  /// [status] là trạng thái mới của đơn hàng.
  ///
  /// Trả về: Một giá trị của enum `HTTPReult` cho biết kết quả của yêu cầu.
  /// - `HTTPReult.ok` nếu thành công.
  /// - `HTTPReult.nofound` nếu đơn hàng không được tìm thấy.
  /// - `HTTPReult.error` nếu có lỗi xảy ra.
  ///
  /// Ví dụ:
  /// ```dart
  /// final result = await orderAPI.updateStatus(orderID: '123', status: 'shipped');
  /// ```
  Future<HTTPReult> updateStatus({required String orderID, required String status}) async {
    final response = await http.post(Uri.parse('$apiUrl/api/updateStatus?order_id=$orderID&status=$status'));

    if (response.statusCode == 200) {
      return HTTPReult.ok;
    } else if (response.statusCode == 404) {
      return HTTPReult.nofound;
    } else {
      return HTTPReult.error;
    }
  }

  /// Cập nhật giá tổng của một đơn hàng.
  ///
  /// [orderID] là ID của đơn hàng cần cập nhật.
  /// [price] là giá tổng mới của đơn hàng.
  ///
  /// Trả về: Một giá trị của enum `HTTPReult` cho biết kết quả của yêu cầu.
  /// - `HTTPReult.ok` nếu thành công.
  /// - `HTTPReult.nofound` nếu đơn hàng không được tìm thấy.
  /// - `HTTPReult.error` nếu có lỗi xảy ra.
  ///
  /// Ví dụ:
  /// ```dart
  /// final result = await orderAPI.updateTotalPrice(orderID: '123', price: 199.99);
  /// ```
  Future<HTTPReult> updateTotalPrice({required String orderID, required double price}) async {
    final response = await http.post(Uri.parse('$apiUrl/api/updateTotalPrice?order_id=$orderID&total_price=$price'));

    if (response.statusCode == 200) {
      return HTTPReult.ok;
    } else if (response.statusCode == 404) {
      return HTTPReult.nofound;
    } else {
      return HTTPReult.error;
    }
  }

  /// Xóa một đơn hàng khỏi hệ thống.
  ///
  /// [orderID] là ID của đơn hàng cần xóa.
  ///
  /// Trả về: Một giá trị của enum `HTTPReult` cho biết kết quả của yêu cầu.
  /// - `HTTPReult.ok` nếu thành công.
  /// - `HTTPReult.nofound` nếu đơn hàng không được tìm thấy.
  /// - `HTTPReult.error` nếu có lỗi xảy ra.
  ///
  /// Ví dụ:
  /// ```dart
  /// final result = await orderAPI.deleteOrder(orderID: '123');
  /// ```
  Future<HTTPReult> deleteOrder({required String orderID}) async {
    final response = await http.delete(Uri.parse('$apiUrl/api/deleteOrder?order_id=$orderID'));

    if (response.statusCode == 200) {
      return HTTPReult.ok;
    } else if (response.statusCode == 404) {
      return HTTPReult.nofound;
    } else {
      return HTTPReult.error;
    }
  }
}
