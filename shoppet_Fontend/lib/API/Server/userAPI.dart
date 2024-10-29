import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:shoppet_fontend/API/Local/config.dart';

import '../../Model/apiModel/userModel.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class userAPI {

  String apiUrl = config.apiUrl;



  Future<List<User>?> getUsersByIds(List<String> userIds) async {
    if (userIds.isEmpty) {
      throw ArgumentError('userIds cannot be empty');
    }

    // Tạo body JSON từ danh sách UUID
    final body = jsonEncode(userIds); // Chỉ cần gửi danh sách UUID trực tiếp

    try {
      // Gửi yêu cầu POST với body chứa danh sách UUID
      final response = await http.post(
        Uri.parse('$apiUrl/api/getUsersByIDs'),
        headers: {
          'Content-Type': 'application/json', // Đảm bảo header chứa thông tin định dạng JSON
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Chuyển đổi JSON response thành danh sách các đối tượng User
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        List<User> users = jsonResponse.map((data) => User.fromJson(data)).toList();
        return users;
      } else {
        // Nếu status code khác 200, in ra lỗi
        print("Failed to load user data: ${response.statusCode}");
        print(body);
        return null;
      }
    } catch (e) {
      // Bắt và xử lý lỗi trong quá trình gọi API
      print('Error: $e');
      throw Exception('Failed to load user data');
    }
  }




  /// Lấy thông tin người dùng dựa trên [userId].
  ///
  /// Nếu không truyền vào [userId], giá trị mặc định là `"none"`.
  ///
  /// **Tham số:**
  /// - [userId]: ID của người dùng cần lấy thông tin. Nếu không cung cấp, mặc định là `"none"`.
  ///
  /// **Trả về:**
  /// - Một đối tượng `User` nếu thành công hoặc `null` nếu có lỗi xảy ra.
  ///
  /// **Lưu ý:**
  /// - Đảm bảo rằng `userId` không phải là `"none"` khi gọi hàm để tránh lỗi.
  Future<User?> getUserById([String userId = "none"]) async {
    try {
      final response = await http.get(
          Uri.parse('$apiUrl/api/getUser?user_id=$userId'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse;
        if (response.headers['content-type']?.contains('charset=utf-8') ??
            false) {
          jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        } else {
          jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        }
        List<dynamic> data = jsonResponse;
        return User.fromJson(data[0]);
      } else {
        print("Failed to load user data");
        return null;
      }
    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Lấy thông tin người dùng dựa trên [username].
  ///
  /// Nếu không truyền vào [username], giá trị mặc định là `"none"`.
  ///
  /// **Tham số:**
  /// - [username]: Tên của người dùng cần lấy thông tin. Nếu không cung cấp, mặc định là `"none"`.
  ///
  /// **Trả về:**
  /// - Một đối tượng `User` nếu thành công hoặc `null` nếu có lỗi xảy ra.
  ///
  /// **Lưu ý:**
  /// - Đảm bảo rằng `username` không phải là `"none"` khi gọi hàm để tránh lỗi.
  Future<User?> getUserByName([String username = "none"]) async {
    try {
      final response = await http.get(
          Uri.parse('$apiUrl/api/getUser?username=$username'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse;
        if (response.headers['content-type']?.contains('charset=utf-8') ??
            false) {
          jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        } else {
          jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        }
        List<dynamic> data = jsonResponse;
        return User.fromJson(data[0]);
      } else {
        print("Failed to load user data");
        return null;
      }
    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Lấy thông tin người dùng dựa trên [mail].
  ///
  /// Nếu không truyền vào [mail], giá trị mặc định là `"none"`.
  ///
  /// **Tham số:**
  /// - [mail]: mail của người dùng cần lấy thông tin. Nếu không cung cấp, mặc định là `"none"`.
  ///
  /// **Trả về:**
  /// - Một đối tượng `User` nếu thành công hoặc `null` nếu có lỗi xảy ra.
  ///
  /// **Lưu ý:**
  /// - Đảm bảo rằng `mail` không phải là `"none"` khi gọi hàm để tránh lỗi.
  Future<List<User>?> getUserByMail([String mail = "none"]) async {
    try {
      final response = await http.get(
          Uri.parse('$apiUrl/api/getUser?mail=$mail'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse;
        if (response.headers['content-type']?.contains('charset=utf-8') ??
            false) {
          jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        } else {
          jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        }
        List<dynamic> data = jsonResponse;

        List<User> listUsers = [];

        data.forEach((item){
          listUsers.add(User.fromJson(item));
        });

        return listUsers;
      } else {
        print("Failed to load user data");
        return null;
      }
    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Cập nhật thông tin người dùng trong hệ thống thông qua HTTP PUT request.
  ///
  /// Phương thức này cho phép cập nhật các trường thông tin của người dùng như tên, email, số điện thoại, địa chỉ và mật khẩu.
  /// Chỉ những trường có giá trị khác "none" hoặc 0 mới được cập nhật.
  ///
  /// Tham số:
  /// - [user_id]: ID của người dùng cần cập nhật (bắt buộc).
  /// - [name]: Tên mới của người dùng (tùy chọn). Mặc định là "none". Chỉ cập nhật nếu khác "none".
  /// - [mail]: Email mới của người dùng (tùy chọn). Mặc định là "none". Chỉ cập nhật nếu khác "none".
  /// - [phone]: Số điện thoại mới của người dùng (tùy chọn). Mặc định là 0. Chỉ cập nhật nếu khác 0.
  /// - [address]: Địa chỉ mới của người dùng (tùy chọn). Mặc định là "none". Chỉ cập nhật nếu khác "none".
  /// - [password]: Mật khẩu mới của người dùng (tùy chọn). Mặc định là "none". Chỉ cập nhật nếu khác "none".
  ///
  /// Trả về:
  /// - Một [Future<String>] chứa kết quả của thao tác cập nhật. Có thể là:
  ///   - "update success": Cập nhật thành công.
  ///   - "user not found": Người dùng không tồn tại.
  ///   - Mã trạng thái HTTP dưới dạng chuỗi: Nếu xảy ra lỗi khác.
  ///
  /// Ví dụ:
  /// ```dart
  /// String result = await updateUser("12345", name: "Jane Doe", mail: "jane.doe@example.com");
  /// print(result); // Có thể in ra "update success" hoặc mã trạng thái HTTP
  /// ```
  ///
  /// URL API sử dụng là `$apiUrl/api/updateUser`, trong đó `$apiUrl` là URL cơ sở của API.
  Future<String> updateUser(String user_id, {String name = "none", String mail = "none", int phone = 0, String address = "none", String password = "none", File? image}) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$apiUrl/api/updateUser'));

      // Thêm các field vào request
      request.fields['user_id'] = user_id;
      if (name != "none") request.fields['name'] = name;
      if (mail != "none") request.fields['mail'] = mail;
      if (phone != 0) request.fields['phone'] = phone.toString();
      if (address != "none") request.fields['address'] = address;
      if (password != "none") request.fields['password'] = password;

      // Nếu có file ảnh, thêm vào multipart request
      if (image != null) {
        var stream = http.ByteStream(image.openRead());
        var length = await image.length(); // Lấy độ dài của file

        // Tạo đối tượng MultipartFile và thêm vào request
        var multipartFile = http.MultipartFile(
          'image', // Tên field cho file ảnh
          stream,
          length,
          filename: "avatar", // Lấy tên file
        );

        request.files.add(multipartFile); // Thêm file vào request
      }

      // Gửi request
      var response = await request.send();

      // Xử lý phản hồi
      if (response.statusCode == 200) {
        return "update success";
      } else if (response.statusCode == 404) {
        return "user not found";
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
        return response.statusCode.toString();
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Server error');
    }
  }


  /// Tạo một tài khoản người dùng mới.
  ///
  /// Phương thức này gửi một HTTP POST request để tạo một tài khoản người dùng mới trong hệ thống.
  /// Nó yêu cầu các tham số như tên đăng nhập và mật khẩu, và cho phép cung cấp thêm thông tin như tên, số điện thoại, email và địa chỉ.
  ///
  /// **Tham số:**
  /// - [username] (`String`): Tên đăng nhập của người dùng. Đây là tham số bắt buộc.
  /// - [password] (`String`): Mật khẩu của người dùng. Đây là tham số bắt buộc.
  /// - [name] (`String`, tùy chọn): Tên của người dùng. Mặc định là `"none"`. Chỉ cập nhật nếu khác `"none"`.
  /// - [phone] (`int`, tùy chọn): Số điện thoại của người dùng. Mặc định là 0. Chỉ cập nhật nếu khác 0.
  /// - [mail] (`String`, tùy chọn): Email của người dùng. Mặc định là `"none"`. Chỉ cập nhật nếu khác `"none"`.
  /// - [address] (`String`, tùy chọn): Địa chỉ của người dùng. Mặc định là `"none"`. Chỉ cập nhật nếu khác `"none"`.
  ///
  /// **Trả về:**
  /// - Một [Future<int>] chứa mã trạng thái HTTP của phản hồi. Các mã trạng thái có thể bao gồm:
  ///   - `201 Created`: Nếu tài khoản được tạo thành công.
  ///   - `409 Conflict`: Nếu tên đăng nhập đã tồn tại.
  ///   - `500 Internal Server Error`: Nếu có lỗi xảy ra trong quá trình tạo tài khoản.
  ///
  /// **Lưu ý:**
  /// - Đảm bảo rằng các tham số như [username] và [password] được cung cấp để tạo tài khoản.
  /// - Các giá trị mặc định cho [name], [mail], và [address] là `"none"`, và các trường này sẽ không được cập nhật nếu giữ giá trị mặc định.
  /// - Sử dụng mã trạng thái HTTP để xác định kết quả của yêu cầu tạo tài khoản.
  ///
  /// **Ví dụ:**
  /// ```dart
  /// int statusCode = await createUser(
  ///   username: "newuser",
  ///   password: "securepassword",
  ///   name: "John Doe",
  ///   phone: 123456789,
  ///   mail: "john.doe@example.com",
  ///   address: "456 Elm St"
  /// );
  /// if (statusCode == 201) {
  ///   print("Account created successfully");
  /// } else if (statusCode == 409) {
  ///   print("Username already exists");
  /// } else if (statusCode == 500) {
  ///   print("Internal server error");
  /// }
  /// ```
  ///
  /// URL API sử dụng là `$apiUrl/api/createAccount`, trong đó `$apiUrl` là URL cơ sở của API.
  Future<int> createUser({required String username, required String password, String name = "none", int phone = 0, String mail = "none", String address ="none"}) async {
    try {
      final response = await http.post(Uri.parse(
          '$apiUrl/api/createAccount?username=$username&password=$password&name=$name&phone=$phone&mail=$mail&address=$address'));
      return response.statusCode;
    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Kiểm tra xem người dùng có tồn tại trong hệ thống hay không.
  ///
  /// Phương thức này gửi một yêu cầu HTTP GET để kiểm tra xem tên đăng nhập có tồn tại trong hệ thống hay không.
  ///
  /// **Tham số:**
  /// - [username] (`String`): Tên đăng nhập của người dùng cần kiểm tra. Đây là tham số bắt buộc.
  ///
  /// **Trả về:**
  /// - Một [Future<String>] chứa nội dung phản hồi từ server, có thể là chuỗi `"true"` hoặc `"false"`.
  ///   - `"true"`: Nếu người dùng tồn tại.
  ///   - `"false"`: Nếu người dùng không tồn tại.
  ///
  /// **Ví dụ:**
  /// ```dart
  /// String result = await hasUser(username: "existinguser");
  /// if (result == "true") {
  ///   print("User exists in the system.");
  /// } else if (result == "false") {
  ///   print("User does not exist.");
  /// }
  /// ```
  ///
  /// **Lưu ý:**
  /// - Đảm bảo rằng [username] được cung cấp chính xác để tránh kết quả kiểm tra sai.
  /// - Phản hồi của server là một chuỗi đơn giản, có thể được sử dụng để xác định xem người dùng có tồn tại hay không.
  ///
  Future<String> hasUser({required String username}) async {
    try {
      final response = await http.get(
          Uri.parse('$apiUrl/api/checkUser?username=$username'));
      return response.body;
    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

  /// Gửi yêu cầu kiểm tra mật khẩu của người dùng.
  ///
  /// @param username Tên đăng nhập của người dùng (bắt buộc).
  /// @param password Mật khẩu của người dùng (bắt buộc).
  /// @return Future<HTTPReult> trả về kết quả kiểm tra mật khẩu.
  /// - `HTTPReult.ok` nếu yêu cầu thành công và mật khẩu chính xác (mã trạng thái HTTP 200).
  /// - `HTTPReult.Unauthorized` nếu mật khẩu không chính xác hoặc không tìm thấy người dùng (mã trạng thái HTTP 401).
  /// - `HTTPReult.error` nếu có lỗi xảy ra trong quá trình gửi yêu cầu hoặc xử lý phản hồi.
  /// @throws Exception nếu có lỗi xảy ra trong quá trình gửi yêu cầu hoặc xử lý phản hồi.
  Future<HTTPReult> checkpass({required String username, required String password}) async {
    try {
      final response = await http.post(
          Uri.parse('$apiUrl/api/checkpass?username=$username&password=$password'));

      if(response.statusCode == 200){
        return HTTPReult.ok;
      }else if(response.statusCode == 401){
        return HTTPReult.Unauthorized;
      }else{
        return HTTPReult.error;
      }


    }catch(e){
      throw Exception(config.ERROR_SERVER);
    }
  }

}