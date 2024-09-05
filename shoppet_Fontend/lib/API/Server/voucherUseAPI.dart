import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shoppet_fontend/Model/apiModel/voucherUseModel.dart';
import '../Local/config.dart';

class voucherUseAPI{
  String apiUrl = config.apiUrl;

  /// Lấy danh sách các voucher đã sử dụng của người dùng dựa trên [userID].
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy các voucher đã sử dụng của người dùng với [userID].
  ///
  /// Tham số:
  /// - [userID]: ID của người dùng cần lấy thông tin voucher đã sử dụng.
  ///
  /// Trả về:
  /// - Danh sách các đối tượng [voucherUse] nếu thành công, hoặc `null` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<List<voucherUse>?> getVoucherUsebyUserID({required String userID}) async {
    final response = await http.get(Uri.parse('$apiUrl/api/getVouchersByUserId?userId=$userID'));
    if(response.statusCode == 200){

      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<voucherUse> listVoucherUse = [];
      jsonResponse.forEach((item){
        listVoucherUse.add(voucherUse.fromJson(item));
      });

      return listVoucherUse;
    }else{
      return null;
    }
  }

  /// Lấy danh sách các voucher đã sử dụng dựa trên [voucherID].
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy các voucher đã sử dụng với [voucherID].
  ///
  /// Tham số:
  /// - [voucherID]: ID của voucher cần lấy thông tin đã sử dụng.
  ///
  /// Trả về:
  /// - Danh sách các đối tượng [voucherUse] nếu thành công, hoặc `null` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<List<voucherUse>?> getVoucherUsebyVoucherID({required String voucherID}) async {
    final response = await http.get(Uri.parse('$apiUrl/api/getVouchersByUserId?voucherId=$voucherID'));
    if(response.statusCode == 200){

      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<voucherUse> listVoucherUse = [];
      jsonResponse.forEach((item){
        listVoucherUse.add(voucherUse.fromJson(item));
      });

      return listVoucherUse;
    }else{
      return null;
    }
  }

  /// Thêm một voucher sử dụng mới cho người dùng.
  ///
  /// Phương thức này gửi một yêu cầu POST đến API để thêm một voucher sử dụng mới cho người dùng với thông tin [userID] và [voucherID].
  ///
  /// Tham số:
  /// - [userID]: ID của người dùng mà voucher sẽ được thêm.
  /// - [voucherID]: ID của voucher cần thêm.
  ///
  /// Trả về:
  /// - `HTTPReult.ok` nếu thêm voucher thành công.
  /// - `HTTPReult.conflict` nếu có xung đột (ví dụ: voucher đã được sử dụng trước đó).
  /// - `HTTPReult.error` nếu có lỗi xảy ra trong quá trình thêm voucher.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<HTTPReult> addVoucherUse({required String userID, required String voucherID}) async {
    final response = await http.post(Uri.parse('$apiUrl/api/addVoucherUse?&userId=$userID&voucher_id=$voucherID'));

    if(response.statusCode == 201){
      return HTTPReult.ok;
    }else if(response.statusCode == 409){
      return HTTPReult.conflict;
    }else{
      print(response.statusCode);
      return HTTPReult.error;
    }

  }
}