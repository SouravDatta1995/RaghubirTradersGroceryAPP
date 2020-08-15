import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:raghuvir_traders/Elements/Product.dart';

class ProductManagementService {
  static Future<List<Product>> getProducts(int category, int order) async {
    String url = 'http://15.207.50.9:8082/product/GetAll';
    if (category != 0 && order != 0)
      url += "?category=$category&orderBy=$order";
    else if (category != 0)
      url += "?category=$category";
    else if (order != 0) url += "?orderBy=$order";
    // print(url);
    final response = await http.get(url);

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

  static Future<String> addProduct(String productName, String productPrice,
      String fileName, String category) async {
    //print("File: " + fileName);
    String data = "{\"BasePrice\":" +
        double.parse(productPrice).toString() +
        ", \"Name\":\"" +
        productName +
        "\", " +
        "\"Category\":\"" +
        category +
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

  static Future<String> updateProduct(String productName, String productPrice,
      String fileName, String category) async {
    String data = "{\"BasePrice\":" +
        double.parse(productPrice).toString() +
        ", \"Name\":\"" +
        productName +
        "\", " +
        "\"Category\":\"" +
        category +
        "\"}";
    //print("Data: " + data);
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
      //print("Product Added");
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

  static Future<String> deleteProduct(Product product) async {
    final response = await http.put('http://15.207.50.9:8082/product/Delete/',
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()));

    if (response.statusCode == 200) {
      return "Success";
    } else {
      return "Failure";
    }
  }
}
