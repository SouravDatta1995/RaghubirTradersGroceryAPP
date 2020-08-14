import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:raghuvir_traders/Elements/Cart.dart';

class OrderHistoryService {
  static Future<List<Cart>> getLastOrder(int customerId) async {
    List<Cart> cartList = [];

    final response = await http
        .get("http://15.207.50.9:8082/basket/GetLastOrders/$customerId");

    if (response.statusCode == 200) {
      List<dynamic> a = List.from(json.decode(response.body));
      a.forEach((element) {
        cartList.add(Cart.fromJson(element));
      });
      return cartList;
    } else {
      return cartList;
    }
  }

  static Future<List<Cart>> getPendingOrders() async {
    List<Cart> cartList = [];

    final response =
        await http.get("http://15.207.50.9:8082/basket/GetPendingOrders/");
    if (response.statusCode == 200) {
      List<dynamic> a = List.from(json.decode(response.body));
      a.forEach((element) {
        cartList.add(Cart.fromJson(element));
      });
      return cartList;
    } else {
      return cartList;
    }
  }

  static Future<String> updateBasketDelivery({int basketId, int userId}) async {
    //print(basketId.toString() + " " + userId.toString());
    final response = await http.put(
        "http://15.207.50.9:8082/basket/UpdateBasketDelivery/$userId/$basketId");
    if (response.statusCode == 200) {
      return "Success";
    } else {
      return "Error";
    }
  }
}
