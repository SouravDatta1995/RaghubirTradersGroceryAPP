import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/Elements/Product.dart';
import 'package:raghuvir_traders/Elements/UserData.dart';
import 'package:raghuvir_traders/Services/CartManagementService.dart';
import 'package:rxdart/rxdart.dart';

class AppDataBLoC {
  static final AppDataBLoC appDataBLoC = new AppDataBLoC._internal();
  static Cart cart;
  static UserData data;
  static int basketId, pin;
  static String deliveryAddress;
  static List<String> categoryList = [
    "View All",
    "Fruits & Vegetables",
    "Foodgrains, Oil & Masala",
    "Bakery, Cakes & Dairy",
    "Beverages",
    "Snacks & Branded Foods",
    "Beauty & Hygiene",
    "Cleaning & Household",
    "Kitchen, Garden & Pets",
    "Eggs,Meat & Fish",
    "Gourmet & World Food",
    "Baby Care",
  ];
  final cartStream = BehaviorSubject<Cart>();
  final cartNum = BehaviorSubject<int>();
  AppDataBLoC(UserData userData, int basketIdStr) {
    data = userData;
    basketId = basketIdStr;
    //return appDataBLoC;
  }
  AppDataBLoC._internal() {
    int itemCount = 0;
    cartNum.add(itemCount);
    cartStream.add(cart);
  }
  dispose() {
    appDataBLoC.dispose();
  }

  cartNumAdd(Product product, int quantity) {
    double totalPrice = 0.0;
    int itemCount = 0;
    BasketDetails b = BasketDetails();
    if (cart.basketId != 0) {
      cart.basketDetails.firstWhere((element) {
        if (element.product.productId == product.productId)
          element.quantity = quantity;
        return element.product.productId == product.productId;
      }, orElse: () {
        cart.basketDetails
            .add(BasketDetails(product: product, quantity: quantity));
        return null;
      });
      cart.basketDetails.forEach((element) {
        totalPrice += element.quantity * element.product.price;
        itemCount += element.quantity;
      });
      cartNum.add(itemCount);
      cart.totalPrice = totalPrice;
      cartStream.add(cart);
      CartManagementService.updateCart(cart);
    } else {
      Cart newCart = Cart();
      CartManagementService.getLastCart(data.id).then((value) {
        if (value.keys.toList()[0] == "Cart Details") {
          newCart = value.values.toList()[0];
          newCart.basketDetails
              .firstWhere(
                  (element) => element.product.productId == product.productId)
              .quantity += 1;
          CartManagementService.updateCart(newCart).then((value) {
            if (value.keys.toList()[0] == "Success") {
              cart = value.values.toList()[0];
              print(cart.basketId.toString());
              cartNum.add(1);
              cartStream.add(cart);
            }
          });
        } else if (value.keys.toList()[0] == "New Cart") {
          newCart = Cart(
              customer: data,
              basketDetails: [BasketDetails(product: product, quantity: 1)],
              totalPrice: product.price);
          CartManagementService.updateCart(newCart).then((value) {
            if (value.keys.toList()[0] == "Success") {
              cart = value.values.toList()[0];
              print(cart.basketId.toString());
              cartNum.add(1);
              cartStream.add(cart);
            }
          });
        }
      });
    }
  }

  cartUpdate() {
    CartManagementService.updateCart(cart).then((value) {
      Cart c = value.values.toList()[0];
      //print(c.toJson().toString());
      AppDataBLoC.cart = c;
      cartStream.add(c);
    });
  }

  static Future<void> setLastCart() async {
    CartManagementService.getLastCart(AppDataBLoC.data.id).then((value) {
      if (value.keys.toList()[0] == "Cart Details") {
        Cart c = value.values.toList()[0];
        AppDataBLoC.basketId = c.basketId;
        AppDataBLoC.cart = c;
        AppDataBLoC.appDataBLoC.cartStream.add(c);
        int count = 0;
        AppDataBLoC.cart.basketDetails.forEach((element) {
          count += element.quantity;
          AppDataBLoC.appDataBLoC.cartNum.add(count);
        });
      } else if (value.keys.toList()[0] == "New Cart") {
        Cart c = value.values.toList()[0];
        AppDataBLoC.basketId = 0;
        AppDataBLoC.cart = c;
        AppDataBLoC.appDataBLoC.cartStream.add(c);
        AppDataBLoC.appDataBLoC.cartNum.add(0);
      }
    });
  }
}
