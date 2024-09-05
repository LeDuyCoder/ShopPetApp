import 'dart:convert';

import 'package:shoppet_fontend/Model/apiModel/payment.dart';

import '../Local/config.dart';
import 'package:http/http.dart' as http;

class paymentAPI{
  String apiUrl = config.apiUrl;

  /// Lấy danh sách tất cả các khoản thanh toán.
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy tất cả các khoản thanh toán.
  ///
  /// Trả về:
  /// - Danh sách các đối tượng [payment] nếu thành công, hoặc `null` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<List<payment>?> getPayments() async {
    final response = await http.get(Uri.parse('$apiUrl/api/getPayment'));
    
    if(response.statusCode == 200){
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<payment> listPayments = [];
      
      jsonResponse.forEach((item){
        listPayments.add(payment.fromJson(item));
      });

      return listPayments;
    }else{
      return null;
    }
  }

  /// Lấy danh sách các khoản thanh toán dựa trên [payment_id].
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy các khoản thanh toán với [payment_id].
  ///
  /// Tham số:
  /// - [payment_id]: ID của khoản thanh toán cần lấy thông tin.
  ///
  /// Trả về:
  /// - Danh sách các đối tượng [payment] nếu thành công, hoặc `null` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<List<payment>?> getPaymentby({required String payment_id}) async {
    final response = await http.get(Uri.parse('$apiUrl/api/getPayment?payment_id=$payment_id'));

    if(response.statusCode == 200){
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<payment> listPayments = [];

      jsonResponse.forEach((item){
        listPayments.add(payment.fromJson(item));
      });

      return listPayments;
    }else{
      return null;
    }
  }

  /// Tạo một khoản thanh toán mới.
  ///
  /// Phương thức này gửi một yêu cầu POST đến API để thêm một khoản thanh toán mới với [order_id], [payment_method], và [status].
  ///
  /// Tham số:
  /// - [order_id]: ID của đơn hàng mà khoản thanh toán liên quan đến.
  /// - [payment_method]: Phương thức thanh toán sử dụng.
  /// - [status]: Trạng thái thanh toán (true nếu đã thanh toán, false nếu chưa).
  ///
  /// Trả về:
  /// - `HTTPReult.ok` nếu tạo khoản thanh toán thành công.
  /// - `HTTPReult.error` nếu có lỗi xảy ra trong quá trình tạo khoản thanh toán.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<HTTPReult> createPayment({
    required String order_id,
    required String payment_method,
    required bool status
  }) async {
    final response = await http.post(Uri.parse('$apiUrl/api/addPayment?order_id=$order_id&payment_method=$payment_method&status=$status'));

    if(response.statusCode == 201){
      return HTTPReult.ok;
    }else{
      print(response.statusCode);
      return HTTPReult.error;
    }
  }

  /// Xóa một khoản thanh toán.
  ///
  /// Phương thức này gửi một yêu cầu DELETE đến API để xóa một khoản thanh toán dựa trên [payment_id].
  ///
  /// Tham số:
  /// - [payment_id]: ID của khoản thanh toán cần xóa.
  ///
  /// Trả về:
  /// - `HTTPReult.ok` nếu xóa khoản thanh toán thành công.
  /// - `HTTPReult.error` nếu có lỗi xảy ra trong quá trình xóa khoản thanh toán.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<HTTPReult> removePayment({required String payment_id}) async {
    final response = await http.delete(Uri.parse('$apiUrl/api/removePayment?payment_id=$payment_id'));

    if(response.statusCode == 204){
      return HTTPReult.ok;
    }else{
      return HTTPReult.error;
    }

  }
}