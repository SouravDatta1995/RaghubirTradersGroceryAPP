import 'package:raghuvir_traders/Elements/Product.dart';
import 'package:raghuvir_traders/Elements/UserData.dart';

class Cart {
  int basketId;
  UserData customer;
  List<BasketDetails> basketDetails;
  double totalPrice;
  bool isPaid;
  bool isDelivered;
  String paymentMode, deliveryAddress;

  Cart({this.basketId, this.customer, this.basketDetails, this.totalPrice});

  Cart.fromJson(Map<String, dynamic> json) {
    basketId = json['basket_id'];
    customer = json['Customer'] != null
        ? new UserData.fromJSON(json['Customer'])
        : null;
    if (json['BasketDetails'] != null) {
      basketDetails = new List<BasketDetails>();
      json['BasketDetails'].forEach((v) {
        basketDetails.add(new BasketDetails.fromJson(v));
      });
    }
    totalPrice = json['TotalPrice'];
    isPaid = json['IsPaid'];
    isDelivered = json['IsDelivered'];
    paymentMode = json['PaymentMode'] ?? "";
    deliveryAddress = json['DeliveryAddress'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.basketId;
    if (this.customer != null) {
      data['Customer'] = this.customer.toJson();
    }
    if (this.basketDetails != null) {
      data['BasketDetails'] =
          this.basketDetails.map((v) => v.toJson()).toList();
    }
    data['TotalPrice'] = this.totalPrice;
    return data;
  }
}

class BasketDetails {
  Product product;
  int quantity;

  BasketDetails({this.product, this.quantity});

  BasketDetails.fromJson(Map<String, dynamic> json) {
    product =
        json['Product'] != null ? new Product.fromJson(json['Product']) : null;
    quantity = json['Quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['Product'] = this.product.toJson();
    }
    data['Quantity'] = this.quantity;
    return data;
  }
}
