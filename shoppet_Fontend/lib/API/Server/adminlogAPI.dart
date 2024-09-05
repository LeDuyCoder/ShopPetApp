import 'dart:convert';

import 'package:shoppet_fontend/API/Local/config.dart';
import 'package:http/http.dart' as http;
import 'package:shoppet_fontend/Model/apiModel/adminlogModel.dart';

class adminlogAPI{
  String apiUrl = config.apiUrl;

  /// Lấy danh sách các nhật ký quản trị từ hệ thống.
  ///
  /// **Trả về:**
  /// - Một danh sách `List<Adminlog>` chứa các đối tượng nhật ký nếu thành công.
  /// - `null` nếu không có dữ liệu hoặc có lỗi xảy ra.
  ///
  /// **Lưu ý:**
  /// - Hàm này sẽ ném ra một ngoại lệ nếu xảy ra lỗi kết nối với máy chủ.
  Future<List<Adminlog>?> getLogs() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/getLogs'));

      if(response.statusCode == 200){
        List<dynamic> jsonResponse;
        if (response.headers['content-type']?.contains('charset=utf-8') ??
            false) {
          jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        } else {
          jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        }

        List<Adminlog> adminlogs = [];
        jsonResponse.forEach((item){
          adminlogs.add(Adminlog.fromJson(item));
        });

        return adminlogs;
      }else{
        return null;
      }
    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Thêm một nhật ký quản trị mới vào hệ thống.
  ///
  /// **Tham số:**
  /// - [admin_id]: ID của quản trị viên thực hiện hành động. Đây là tham số bắt buộc.
  /// - [action]: Hành động được thực hiện bởi quản trị viên. Đây là tham số bắt buộc.
  ///
  /// **Trả về:**
  /// - `HTTPReult.ok` nếu thêm nhật ký thành công.
  /// - `HTTPReult.forbidden` nếu quản trị viên không có quyền thực hiện hành động.
  /// - `HTTPReult.nofound` nếu không tìm thấy quản trị viên.
  /// - `HTTPReult.error` nếu có lỗi khác xảy ra.
  ///
  /// **Lưu ý:**
  /// - Hàm này sẽ ném ra một ngoại lệ nếu xảy ra lỗi kết nối với máy chủ.
  Future<HTTPReult> addLog({required String admin_id, required String action}) async {
    try {
      final response = await http.post(Uri.parse('$apiUrl/api/addLog?admin_id=$admin_id&action=$action'));

      if(response.statusCode == 200){
        return HTTPReult.ok;
      }else if(response.statusCode == 403){
        return HTTPReult.forbidden;
      }else if(response.statusCode == 404){
        return HTTPReult.nofound;
      }else{
        return HTTPReult.error;
      }

    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Xóa một nhật ký quản trị khỏi hệ thống dựa trên [log_id].
  ///
  /// **Tham số:**
  /// - [log_id]: ID của nhật ký cần xóa. Đây là tham số bắt buộc.
  ///
  /// **Trả về:**
  /// - `HTTPReult.ok` nếu xóa nhật ký thành công.
  /// - `HTTPReult.nofound` nếu không tìm thấy nhật ký.
  /// - `HTTPReult.error` nếu có lỗi khác xảy ra.
  ///
  /// **Lưu ý:**
  /// - Hàm này sẽ ném ra một ngoại lệ nếu xảy ra lỗi kết nối với máy chủ.
  Future<HTTPReult> removeLog({required String log_id}) async {
    try{
      final response = await http.delete(Uri.parse('$apiUrl/api/deleteLog?log_id=$log_id'));

      if(response.statusCode == 200){
        return HTTPReult.ok;
      }else if(response.statusCode == 404){
        return HTTPReult.nofound;
      }else{
        return HTTPReult.error;
      }
    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

}