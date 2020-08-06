import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:raghuvir_traders/Elements/Cart.dart';

class CartManagementService {
  static Future<Map<String, dynamic>> getCart(int basketId) async {
    print("getCart Called");
    final response =
        await http.get('http://15.207.50.9:8082/basket/Get?$basketId');
    if (response.statusCode == 200)
      return {"Cart Details": Cart.fromJson(json.decode(response.body))};
    else
      return {"Error": "Some Error Occurred"};
  }

  static Future<Map<String, dynamic>> getLastCart(int userId) async {
    print("getCart Called");
    final response =
        await http.get('http://15.207.50.9:8082/basket/GetLastBasket/$userId');
    print(response.statusCode.toString());
    if (response.statusCode == 200)
      return {"Cart Details": Cart.fromJson(json.decode(response.body))};
    else if (response.statusCode == 409)
      return {
        "New Cart": Cart(basketId: 0, basketDetails: List<BasketDetails>())
      };
    else {
      return {"Error": "Some Error Occurred"};
    }
  }

  static Future<Map<String, dynamic>> updateCart(Cart cart) async {
    final response = await http.post(
      'http://15.207.50.9:8082/basket/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(cart.toJson()),
    );
    if (response.statusCode == 201) {
      //print("Success" + response.body);
      return {"Success": Cart.fromJson(json.decode(response.body))};
    } else {
      //print("Fail");
      return {"Error": "Some Error Occurred"};
    }
  }
}
