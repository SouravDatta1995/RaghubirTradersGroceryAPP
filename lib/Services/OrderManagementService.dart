import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:raghuvir_traders/Elements/RazorPayOptions.dart';

class OrderManagementService {
  static Future<Map<String, dynamic>> initiateCheckout(
      double amount, int basketId, int customerId) async {
    print(basketId.toString());
    final response = await http.post(
      'http://15.207.50.9:8082/checkout/initiate',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Amount': amount,
        'BasketId': basketId,
        'CustomerId': customerId
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
      return {"Success": RazorPayOptions.fromJson(jsonDecode(response.body))};
    } else {
      print(response.body);
      return {"Error": "Some error occurred"};
    }
  }
}
