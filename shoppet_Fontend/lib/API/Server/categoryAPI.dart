import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shoppet_fontend/API/Local/config.dart';
import 'package:shoppet_fontend/Model/apiModel/categoryModel.dart';

class categoryAPI {
  String apiUrl = config.apiUrl;

  /// Lấy danh sách các danh mục từ cơ sở dữ liệu.
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy danh sách các danh mục.
  /// Nếu tham số [categoryId] được cung cấp, nó sẽ lấy thông tin của danh mục
  /// tương ứng với ID này. Nếu không, phương thức sẽ lấy tất cả các danh mục từ cơ sở dữ liệu.
  ///
  /// Tham số:
  /// - [categoryId]: UUID của danh mục cần lấy. Nếu không có tham số này, tất cả các danh mục sẽ được lấy.
  ///
  /// Trả về:
  /// - Một `List<Category>?` chứa danh sách các danh mục nếu yêu cầu thành công.
  /// - `null` nếu yêu cầu không thành công.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<List<Category>?> getCategories({String? categoryId = "none"}) async {
    try {
      final response = await http.get(
          Uri.parse('$apiUrl/api/getCategory?category_id=$categoryId'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        List<Category> listCategories = [];
        jsonResponse.forEach((item){
          listCategories.add(Category.fromJson(item));
        });
        return listCategories;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Cập nhật thông tin danh mục dựa trên các tham số truyền vào.
  ///
  /// Phương thức này gửi một yêu cầu PUT đến API để cập nhật thông tin của danh mục có [categoryId].
  /// Các tham số tùy chọn [name] và [parentId] có thể được sử dụng để cập nhật tên và danh mục cha của danh mục.
  ///
  /// Tham số:
  /// - [categoryId]: UUID của danh mục cần cập nhật. Bắt buộc phải có.
  /// - [name]: Tên mới của danh mục. Nếu không có giá trị này, tên hiện tại sẽ không thay đổi.
  /// - [parentId]: UUID của danh mục cha mới. Nếu không có giá trị này, danh mục cha hiện tại sẽ không thay đổi.
  ///
  /// Trả về:
  /// - `HTTPReult.ok` nếu cập nhật thành công.
  /// - `HTTPReult.nofound` nếu danh mục không được tìm thấy.
  /// - `HTTPReult.error` nếu có lỗi xảy ra trong quá trình cập nhật.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<HTTPReult> updateCategory({required String categoryId, String? name, String? parentId}) async {
    try {
      final url = Uri.parse('$apiUrl/api/updateCategory?category_id=$categoryId'
          '${name != null ? '&name=$name' : ''}'
          '${parentId != null ? '&parent_id=$parentId' : ''}');

      final response = await http.put(url);

      if (response.statusCode == 200) {
        return HTTPReult.ok;
      }else if(response.statusCode == 404){
        return HTTPReult.nofound;
      }else {
        return HTTPReult.error;
      }
    } catch (e) {
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Thêm một danh mục mới vào cơ sở dữ liệu.
  ///
  /// Phương thức này gửi một yêu cầu POST đến API để thêm một danh mục mới với thông tin được cung cấp.
  ///
  /// Tham số:
  /// - [categoryId]: UUID của danh mục mới. Bắt buộc phải có.
  /// - [name]: Tên của danh mục mới. Bắt buộc phải có.
  /// - [parentId]: UUID của danh mục cha (tùy chọn).
  ///
  /// Trả về:
  /// - `HTTPReult.ok` nếu thêm thành công.
  /// - `HTTPReult.conflict` nếu danh mục đã tồn tại.
  /// - `HTTPReult.error` nếu có lỗi xảy ra trong quá trình thêm.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<HTTPReult> addCategory({required String categoryId, required String name, String? parentId}) async {
    try {
      final url = Uri.parse('$apiUrl/api/addCategory'
          '?category_id=$categoryId&name=$name'
          '${parentId != null ? '&parent_id=$parentId' : ''}');

      final response = await http.post(url);

      if (response.statusCode == 201) {
        return HTTPReult.ok;
      } else if (response.statusCode == 409) {
        return HTTPReult.conflict;
      } else {
        return HTTPReult.error;
      }
    } catch (e) {
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Xóa một danh mục khỏi cơ sở dữ liệu.
  ///
  /// Phương thức này gửi một yêu cầu DELETE đến API để xóa danh mục có [categoryId].
  ///
  /// Tham số:
  /// - [categoryId]: UUID của danh mục cần xóa. Bắt buộc phải có.
  ///
  /// Trả về:
  /// - `HTTPReult.ok` nếu xóa thành công.
  /// - `HTTPReult.nofound` nếu danh mục không được tìm thấy.
  /// - `HTTPReult.conflict` nếu không thể xóa do có dữ liệu đang tham chiếu.
  /// - `HTTPReult.error` nếu có lỗi xảy ra trong quá trình xóa.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<HTTPReult> deleteCategory({required String categoryId}) async {
    try {
      final url = Uri.parse('$apiUrl/api/deleteCategory?category_id=$categoryId');

      final response = await http.delete(url);

      if (response.statusCode == 204) {
        return HTTPReult.ok;
      } else if (response.statusCode == 404) {
        return HTTPReult.nofound;
      } else if (response.statusCode == 409) {
        return HTTPReult.conflict; // có dữ liệu còn đang tham chiếu
      } else {
        return HTTPReult.error;
      }
    } catch (e) {
      throw Exception(config.ERROR_SERVER);
    }
  }
}
