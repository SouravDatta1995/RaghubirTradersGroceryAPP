import 'dart:convert';

import 'package:http/http.dart' as http;

class AdminLogin {
  static Future<String> adminLogin(String uName, String pass) async {
    print("Details" + uName + pass);
    final response = await http.post(
      "http://15.207.50.9:8082/admin/Get/$uName/$pass",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 201) {
      return "Success";
    } else {
      return "Error";
    }
  }

  static Future<String> validatePassword(
      String uName, String secretAnswer) async {
    final response = await http.post(
      "http://15.207.50.9:8082/admin/Validate/$uName/$secretAnswer",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 201) {
      return "Success";
    } else {
      return "Error";
    }
  }

  static Future<String> resetPassword(
      String uName, String secretAnswer, String newPass) async {
    print("Details: " + uName + secretAnswer + newPass);
    final response = await http.post(
      "http://15.207.50.9:8082/admin/ResetPassword/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'UserName': uName,
        'Password': newPass,
        'SecretAnswer': secretAnswer
      }),
    );

    if (response.statusCode == 201) {
      return "Success";
    } else {
      return "Error";
    }
  }
}
