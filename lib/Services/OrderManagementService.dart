import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:raghuvir_traders/Elements/RazorPayOptions.dart';

class OrderManagementService {
  static Future<Map<String, dynamic>> initiateCheckout(double amount,
      int basketId, int customerId, String deliveryAddress) async {
    final response = await http.post(
      'http://15.207.50.9:8082/checkout/initiate',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Amount': amount,
        'BasketId': basketId,
        'CustomerId': customerId,
        'DeliveryAddress': deliveryAddress
      }),
    );

    if (response.statusCode == 200) {
      return {"Success": RazorPayOptions.fromJson(jsonDecode(response.body))};
    } else {
      return {"Error": "Some error occurred"};
    }
  }

  static Future<dynamic> updatePayment(
      double amount, int basketId, int customerId, String paymentMode) async {
    final response = await http.put(
      'http://15.207.50.9:8082/basket/UpdatePayment',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Amount': amount,
        'BasketId': basketId,
        'CustomerId': customerId,
        'PaymentMode': paymentMode
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return "Success";
    } else
      return "Error";
  }
}
