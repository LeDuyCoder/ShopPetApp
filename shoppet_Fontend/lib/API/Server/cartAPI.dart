import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shoppet_fontend/Model/apiModel/cartModel.dart';

import '../Local/config.dart';

class cartAPI{
  String apiUrl = config.apiUrl;


  /// Lấy danh sách tất cả các giỏ hàng.
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy tất cả các giỏ hàng.
  ///
  /// Trả về:
  /// - Danh sách các đối tượng [Cart] nếu thành công, hoặc `null` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<List<Cart>?> getCarts() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/getCart'));

      if(response.statusCode == 200){
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        List<Cart> listCarts = [];
        jsonResponse.forEach((item){
            listCarts.add(Cart.fromJson(item));
        });

        return listCarts;
      }else{
        return null;
      }

    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Lấy danh sách giỏ hàng của một người dùng dựa trên [userID].
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy giỏ hàng của người dùng với [userID].
  ///
  /// Tham số:
  /// - [userID]: ID của người dùng cần lấy giỏ hàng.
  ///
  /// Trả về:
  /// - Danh sách các đối tượng [Cart] nếu thành công, hoặc `null` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<List<Cart>?> getCartsbyUserID({required String userID}) async {
    try{
      final response = await http.get(Uri.parse('$apiUrl/api/getCart?user_id=$userID'));
      if(response.statusCode == 200){
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        List<Cart> listCarts = [];
        jsonResponse.forEach((item){
          listCarts.add(Cart.fromJson(item));
        });

        return listCarts;
      }else{
        return null;
      }
    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Lấy danh sách giỏ hàng dựa trên [cartID].
  ///
  /// Phương thức này gửi một yêu cầu GET đến API để lấy giỏ hàng với [cartID].
  ///
  /// Tham số:
  /// - [cartID]: ID của giỏ hàng cần lấy.
  ///
  /// Trả về:
  /// - Danh sách các đối tượng [Cart] nếu thành công, hoặc `null` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<List<Cart>?> getCartsbyCartID({required String cartID}) async {
    try{
      final response = await http.get(Uri.parse('$apiUrl/api/getCart?card_id=$cartID'));
      if(response.statusCode == 200){
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        List<Cart> listCarts = [];
        jsonResponse.forEach((item){
          listCarts.add(Cart.fromJson(item));
        });

        return listCarts;
      }else{
        return null;
      }
    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Tạo một giỏ hàng mới cho người dùng với [userID].
  ///
  /// Phương thức này gửi một yêu cầu POST đến API để tạo một giỏ hàng mới.
  ///
  /// Tham số:
  /// - [userID]: ID của người dùng cho giỏ hàng mới.
  ///
  /// Trả về:
  /// - `HTTPReult.ok` nếu tạo giỏ hàng thành công.
  /// - `HTTPReult.nofound` nếu giỏ hàng đã tồn tại.
  /// - `HTTPReult.error` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<HTTPReult> createCart({required String userID}) async{
    final response = await http.post(Uri.parse('$apiUrl/api/addCart?user_id=$userID'));

    if(response.statusCode == 201){
      return HTTPReult.ok;
    }else if(response.statusCode == 409){
      return HTTPReult.nofound;
    }else{
      return HTTPReult.error;
    }
  }

  /// Xóa giỏ hàng dựa trên [cartID].
  ///
  /// Phương thức này gửi một yêu cầu DELETE đến API để xóa giỏ hàng với [cartID].
  ///
  /// Tham số:
  /// - [cartID]: ID của giỏ hàng cần xóa.
  ///
  /// Trả về:
  /// - `HTTPReult.ok` nếu xóa giỏ hàng thành công.
  /// - `HTTPReult.nofound` nếu không tìm thấy giỏ hàng.
  /// - `HTTPReult.error` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<HTTPReult> removeCartbyCartID({required String cartID}) async {
    final response = await http.delete(Uri.parse('$apiUrl/api/removeCart?card_id=$cartID'));
    if(response.statusCode == 200){
      return HTTPReult.ok;
    }else if(response.statusCode == 409){
      return HTTPReult.nofound;
    }else{
      return HTTPReult.error;
    }
  }

  /// Xóa giỏ hàng của người dùng dựa trên [userID].
  ///
  /// Phương thức này gửi một yêu cầu DELETE đến API để xóa tất cả giỏ hàng của người dùng với [userID].
  ///
  /// Tham số:
  /// - [userID]: ID của người dùng có giỏ hàng cần xóa.
  ///
  /// Trả về:
  /// - `HTTPReult.ok` nếu xóa giỏ hàng thành công.
  /// - `HTTPReult.nofound` nếu không tìm thấy giỏ hàng của người dùng.
  /// - `HTTPReult.error` nếu có lỗi xảy ra.
  ///
  /// Ném ra:
  /// - `Exception` với thông báo lỗi nếu có sự cố khi kết nối với máy chủ.
  Future<HTTPReult> removeCartbyUserID({required String userID}) async {
    final response = await http.delete(Uri.parse('$apiUrl/api/removeCart?user_id=$userID'));
    if(response.statusCode == 200){
      return HTTPReult.ok;
    }else if(response.statusCode == 409){
      return HTTPReult.nofound;
    }else{
      return HTTPReult.error;
    }
  }
}