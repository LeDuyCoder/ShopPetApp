import 'dart:convert';

import 'package:shoppet_fontend/Model/apiModel/visitModel.dart';

import '../Local/config.dart';
import 'package:http/http.dart' as http;

class visitAPI {
  String apiUrl = config.apiUrl;

  Future<List<Visit>?> getVisit(String startDate, String endDate) async {
    final response = await http.get(Uri.parse('$apiUrl/api/getVisits?startDate=$startDate&endDate=$endDate'));

    if(response.statusCode == 200){
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<Visit> vists = [];

      jsonResponse.forEach((item){
        vists.add(Visit.fromJson(item));
      });

      return vists;
    }else{
      return null;
    }
  }

  Future<List<Visit>?> getVisits() async {
    final response = await http.get(Uri.parse('$apiUrl/api/getVisits'));

    if(response.statusCode == 200){
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<Visit> vists = [];

      jsonResponse.forEach((item){
        vists.add(Visit.fromJson(item));
      });

      return vists;
    }else{
      return null;
    }
  }

  Future<HTTPReult> addVisit(String userID) async {
    final response = await http.post(Uri.parse('$apiUrl/api/addVisit?userID=$userID'));

    if(response.statusCode == 201){
      return HTTPReult.ok;
    }else{
      return HTTPReult.error;
    }
  }

}