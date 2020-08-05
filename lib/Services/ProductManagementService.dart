import 'dart:convert';

import 'package:dio/dio.dart';
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
      String productName, String productPrice, String fileName) async {
    //print("File: " + fileName);
    String data = "{\"BasePrice\":" +
        double.parse(productPrice).toString() +
        ", \"Name\":\"" +
        productName +
        "\"}";
    //print(data);
    var dio = Dio();
    FormData formData = FormData.fromMap({
      'productImage': await MultipartFile.fromFile(fileName,
          filename: productName + ".jpg"),
      'product': data
    });
    //print(formData.files[0].value.length.toString());
    final response = await dio.post(
      'http://15.207.50.9:8082/product/',
      data: formData,
    );
    if (response.statusCode == 201) {
      //debugPrint("Product Added");
      return "Product add Successful";
    } else {
      //debugPrint("Product Add unsuccessful");
      return "Error Occurred";
    }
  }

  static Future<String> updateProduct(
      String productName, String productPrice, String fileName) async {
    String data = "{\"BasePrice\":" +
        double.parse(productPrice).toString() +
        ", \"Name\":\"" +
        productName +
        "\"}";
    print("Data: " + data);
    var dio = Dio();
    FormData formData = FormData.fromMap({'product': data});
    if (fileName != "")
      formData.files.add(MapEntry(
          'productImage',
          await MultipartFile.fromFile(fileName,
              filename: productName + ".jpg")));
    final response = await dio.put(
      'http://15.207.50.9:8082/product/',
      data: formData,
    );
    if (response.statusCode == 201) {
      //debugPrint("Product Added");
      return "Product Update Successful";
    } else {
      //debugPrint("Product Add unsuccessful");
      return "Error Occurred";
    }
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
