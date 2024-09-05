import 'dart:convert';

import 'package:shoppet_fontend/Model/apiModel/voucherModel.dart';
import 'package:http/http.dart' as http;
import '../Local/config.dart';

class voucherAPI{
  String apiUrl = config.apiUrl;

  /// Lấy danh sách tất cả các voucher.
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy tất cả các voucher.
  ///
  /// Trả về:
  /// - Danh sách các đối tượng [voucher] nếu thành công, hoặc `null` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<List<voucher>?> getVouchers() async {
    final response = await http.get(Uri.parse('$apiUrl/api/getVouchers'));

    if(response.statusCode == 200){
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<voucher> vouchers = [];

      jsonResponse.forEach((item){
        vouchers.add(voucher.fromJson(item));
      });

      return vouchers;
    }else{
      return null;
    }
  }

  /// Lấy danh sách các voucher dựa trên [voucherID].
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy các voucher với [voucherID].
  ///
  /// Tham số:
  /// - [voucherID]: ID của voucher cần lấy thông tin.
  ///
  /// Trả về:
  /// - Danh sách các đối tượng [voucher] nếu thành công, hoặc `null` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<List<voucher>?> getVoucherbyID({required String voucherID}) async {
    final response = await http.get(Uri.parse('$apiUrl/api/getVouchers?voucher_id=$voucherID'));

    if(response.statusCode == 200){
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<voucher> vouchers = [];

      jsonResponse.forEach((item){
        vouchers.add(voucher.fromJson(item));
      });

      return vouchers;
    }else{
      return null;
    }
  }

  /// Lấy danh sách các voucher dựa trên mã [Code].
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy các voucher với mã [Code].
  ///
  /// Tham số:
  /// - [Code]: Mã của voucher cần lấy thông tin.
  ///
  /// Trả về:
  /// - Danh sách các đối tượng [voucher] nếu thành công, hoặc `null` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<List<voucher>?> getVoucherbyCode({required String Code}) async {
    final response = await http.get(Uri.parse('$apiUrl/api/getVouchers?code=$Code'));

    if(response.statusCode == 200){
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<voucher> vouchers = [];

      jsonResponse.forEach((item){
        vouchers.add(voucher.fromJson(item));
      });

      return vouchers;
    }else{
      return null;
    }
  }


  /// Lấy danh sách các voucher dựa trên khoảng thời gian [startDate] và [endDate].
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy các voucher trong khoảng thời gian [startDate] và [endDate].
  ///
  /// Tham số:
  /// - [startDate]: Ngày bắt đầu của khoảng thời gian (định dạng `dd/MM/yyyy`).
  /// - [endDate]: Ngày kết thúc của khoảng thời gian (định dạng `dd/MM/yyyy`).
  ///
  /// Trả về:
  /// - Danh sách các đối tượng [voucher] nếu thành công, hoặc `null` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<List<voucher>?> getVoucherbyDate({
    required String startDate,
    required String endDate,
  }) async {
    String formattedStartDate = _formatDate(startDate);
    String formattedEndDate = _formatDate(endDate);

    // Gửi request với query parameters
    final response = await http.get(
        Uri.parse('$apiUrl/api/getVouchers?startDate=$formattedStartDate&endDate=$formattedEndDate')
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<voucher> vouchers = [];

      jsonResponse.forEach((item) {
        vouchers.add(voucher.fromJson(item));
      });

      return vouchers;
    } else {
      return null;
    }
  }

  String _formatDate(String date) {
    // Giả định định dạng input là dd/MM/yyyy
    List<String> parts = date.split('/');
    return '${parts[2]}/${int.parse(parts[1])}/${int.parse(parts[0])}';
  }

  /// Tạo một voucher mới.
  ///
  /// Phương thức này gửi một yêu cầu POST đến API để thêm một voucher mới với thông tin trong [datavoucher].
  ///
  /// Tham số:
  /// - [datavoucher]: Dữ liệu voucher cần tạo, được cung cấp dưới dạng [Map<String, dynamic>].
  ///
  /// Trả về:
  /// - `HTTPReult.ok` nếu tạo voucher thành công.
  /// - `HTTPReult.error` nếu có lỗi xảy ra trong quá trình tạo voucher.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<HTTPReult> createVoucher({required Map<String, dynamic> datavoucher}) async {
    String body = json.encode(datavoucher);

    // Send the POST request
    final response = await http.post(
      Uri.parse('$apiUrl/api/addVoucher'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if(response.statusCode == 201){
      return HTTPReult.ok;
    }else{
      return HTTPReult.error;
    }
  }

  /// Xóa một voucher.
  ///
  /// Phương thức này gửi một yêu cầu DELETE đến API để xóa một voucher dựa trên [voucher_id].
  ///
  /// Tham số:
  /// - [voucher_id]: ID của voucher cần xóa.
  ///
  /// Trả về:
  /// - `HTTPReult.ok` nếu xóa voucher thành công.
  /// - `HTTPReult.nofound` nếu voucher không được tìm thấy.
  /// - `HTTPReult.error` nếu có lỗi xảy ra trong quá trình xóa voucher.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<HTTPReult> removeVoucher({required String voucher_id}) async {
    final response = await http.delete(Uri.parse('$apiUrl/api/removeVoucher?voucher_id=$voucher_id'));

    if(response.statusCode == 200){
      return HTTPReult.ok;
    }else if(response.statusCode == 404){
      return HTTPReult.nofound;
    }else{
      return HTTPReult.error;
    }
  }
}