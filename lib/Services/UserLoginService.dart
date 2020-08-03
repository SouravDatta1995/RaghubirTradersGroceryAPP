import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:raghuvir_traders/Elements/UserData.dart';

class UserLoginService {
  static Future<Map<String, dynamic>> loginUser(String phoneNumber) async {
    print("Login url: " + "http://15.207.50.9:8082/users/" + phoneNumber);
    final response = await http.get(
      'http://15.207.50.9:8082/users/' + phoneNumber,
    );
    print("StatusCode: " + response.statusCode.toString());
    if (response.statusCode == 409) {
      return {"New User": null};
    } else if (response.statusCode == 200) {
      return {"Existing User": UserData.fromJSON(json.decode(response.body))};
    } else
      return {"Error": "Some Error Occurred"};
  }

  static Future<Map<String, dynamic>> addUser(
      String phoneNumber, String userName) async {
    //print("Det:" + phoneNumber + userName);
    final response = await http.post(
      'http://15.207.50.9:8082/users/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Number': int.parse(phoneNumber),
        'Name': userName,
      }),
    );
    //print(response.statusCode.toString());
    if (response.statusCode == 202) {
      return {
        "User": UserData(name: userName, phoneNumber: int.parse(phoneNumber))
      };
    } else {
      return {"Error": "Some Error occurred"};
    }
  }
}
