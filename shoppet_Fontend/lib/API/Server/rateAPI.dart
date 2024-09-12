import 'dart:convert';

import '../../Model/apiModel/rateModel.dart';
import '../Local/config.dart';
import 'package:http/http.dart' as http;

class rateAPI {
  String apiUrl = config.apiUrl;

  Future<List<Rate>?> getRates() async {
    final response = await http.get(Uri.parse('$apiUrl/api/getRates'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<Rate> listRate = [];
      for (var item in jsonResponse) {
        listRate.add(Rate.fromJson(item));
      }
      return listRate;
    } else {
      return null;
    }
  }

  // Lấy danh sách rate theo productID
  Future<List<Rate>?> getRatesByProductID(String productID) async {
    final response = await http.get(Uri.parse('$apiUrl/api/getRates?productID=$productID'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<Rate> listRate = [];
      for (var item in jsonResponse) {
        listRate.add(Rate.fromJson(item));
      }
      return listRate;
    } else {
      return null;
    }
  }

  // Lấy danh sách rate theo userID
  Future<List<Rate>?> getRatesByUserID(String userID) async {
    final response = await http.get(Uri.parse('$apiUrl/api/getRates?userID=$userID'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<Rate> listRate = [];
      for (var item in jsonResponse) {
        listRate.add(Rate.fromJson(item));
      }
      return listRate;
    } else {
      return null;
    }
  }

  // Thêm rate mới
  Future<HTTPReult> addRate(String productID, String userID, int rate, [String comment = "none"]) async {
    final response = await http.post(
      Uri.parse('$apiUrl/api/addRate?productID=$productID&userID=$userID&rate=$rate&comment=$comment'),
    );

    if (response.statusCode == 201) {
      return HTTPReult.ok;
    } else {
      return HTTPReult.error;
    }
  }

  // Xóa rate theo rateID
  Future<HTTPReult> deleteRate(String productID, String userID) async {
    final response = await http.delete(Uri.parse('$apiUrl/api/deleteRate?productID=$productID&userID=$userID'));
    if (response.statusCode == 204) {
      return HTTPReult.ok;
    }else if (response.statusCode == 404) {
      return HTTPReult.nofound;
    }else {
      return HTTPReult.error;
    }
  }
}
