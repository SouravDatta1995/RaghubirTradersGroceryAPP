import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:raghuvir_traders/Elements/Product.dart';

class ProductManagementService {
  static Future<List<Product>> getProducts() async {
    final response = await http.get('http://15.207.50.9:8082/product/GetAll');

    if (response.statusCode == 200) {
      List<Product> products = [];
      products = (json.decode(response.body) as List)
          .map((element) => Product.fromJson(element))
          .toList();
      return products;
    } else {
      return null;
    }
  }

  static Future<String> addProduct(
      String productName, String productPrice) async {
    final response = await http.post(
      'http://15.207.50.9:8082/product/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'BasePrice': double.parse(productPrice),
        'Name': productName,
      }),
    );
    if (response.statusCode == 201)
      return "Product add Successful";
    else
      return "Error Occurred";
  }

  static Future<List<Product>> findProducts(String searchString) async {
    final response = await http
        .get('http://15.207.50.9:8082/product/Get?name=$searchString');

    if (response.statusCode == 200) {
      List<Product> products = [];
      products = (json.decode(response.body) as List)
          .map((element) => Product.fromJson(element))
          .toList();
      return products;
    } else {
      return null;
    }
  }
}
