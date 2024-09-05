import 'dart:convert';

import 'package:shoppet_fontend/Model/apiModel/cartItemModel.dart';

import '../Local/config.dart';
import 'package:http/http.dart' as http;

class cartItemAPI{
  String apiUrl = config.apiUrl;

  /// Lấy danh sách tất cả các mục trong giỏ hàng.
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy tất cả các mục trong giỏ hàng.
  ///
  /// Trả về:
  /// - Danh sách các đối tượng [cartItems] nếu thành công, hoặc `null` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<List<cartItems>?> getCartItems() async {
    final response = await http.get(Uri.parse('$apiUrl/api/getCartItems'));

    if(response.statusCode == 200){

      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<cartItems> listCartItems = [];
      jsonResponse.forEach((item){
        listCartItems.add(cartItems.fromJson(item));
      });

      return listCartItems;
    }else{
      return null;
    }
  }

  /// Lấy danh sách các mục trong giỏ hàng dựa trên [cartID].
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy các mục trong giỏ hàng với [cartID].
  ///
  /// Tham số:
  /// - [cartID]: ID của giỏ hàng cần lấy các mục.
  ///
  /// Trả về:
  /// - Danh sách các đối tượng [cartItems] nếu thành công, hoặc `null` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.

  Future<List<cartItems>?> getCartItemsbyCartID({required String cartID}) async {
    final response = await http.get(Uri.parse('$apiUrl/api/getCartItems?cartID=$cartID'));

    if(response.statusCode == 200){

      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<cartItems> listCartItems = [];
      jsonResponse.forEach((item){
        listCartItems.add(cartItems.fromJson(item));
      });

      return listCartItems;
    }else{
      return null;
    }
  }


  /// Tạo một mục mới trong giỏ hàng.
  ///
  /// Phương thức này gửi một yêu cầu POST đến API để thêm một mục vào giỏ hàng với [cartID] và [productID].
  ///
  /// Tham số:
  /// - [cartID]: ID của giỏ hàng mà mục mới sẽ được thêm vào.
  /// - [productID]: ID của sản phẩm cần thêm vào giỏ hàng.
  ///
  /// Trả về:
  /// - `HTTPReult.ok` nếu tạo mục thành công.
  /// - `HTTPReult.nofound` nếu có lỗi xảy ra, như mục không được tìm thấy hoặc dữ liệu không hợp lệ.
  /// - `HTTPReult.error` nếu có lỗi xảy ra trong quá trình tạo mục.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<HTTPReult> createCartItem({required String cartID, required String productID}) async {
    final response = await http.post(Uri.parse('$apiUrl/api/addCartItem?cartID=$cartID&product_ID=$productID'));

      if(response.statusCode == 201){
        return HTTPReult.ok;
      }else if(response.statusCode == 400 || response.statusCode == 409){
        return HTTPReult.nofound;
      }else{
        return HTTPReult.error;
      }
  }

  /// Xóa một mục khỏi giỏ hàng.
  ///
  /// Phương thức này gửi một yêu cầu DELETE đến API để xóa một mục trong giỏ hàng dựa trên [cartID].
  ///
  /// Tham số:
  /// - [cartID]: ID của giỏ hàng mà mục cần xóa thuộc về.
  ///
  /// Trả về:
  /// - `HTTPReult.ok` nếu xóa mục thành công.
  /// - `HTTPReult.badrequire` nếu yêu cầu không hợp lệ.
  /// - `HTTPReult.nofound` nếu không tìm thấy mục hoặc giỏ hàng.
  /// - `HTTPReult.error` nếu có lỗi xảy ra trong quá trình xóa mục.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<HTTPReult> removeCartItem({required String cartID}) async {
    final response = await http.delete(Uri.parse('$apiUrl/api/removeCartItem?cartID=$cartID'));

    if(response.statusCode == 200){
      return HTTPReult.ok;
    }else if(response.statusCode == 400){
      return HTTPReult.badrequire;
    }else if(response.statusCode == 404){
      return HTTPReult.nofound;
    }else{
      return HTTPReult.error;
    }
  }
}