import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/Elements/Product.dart';
import 'package:raghuvir_traders/Elements/UserData.dart';
import 'package:raghuvir_traders/Services/CartManagementService.dart';
import 'package:rxdart/rxdart.dart';

class AppDataBLoC {
  static final AppDataBLoC appDataBLoC = new AppDataBLoC._internal();
  static Cart cart;
  static UserData data;
  static int basketId;
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
      print(cart.toJson().toString());
      CartManagementService.updateCart(cart).then((value) {
        cart = value.values.toList()[0];
        cartStream.add(cart);
      });
    } else {
      Cart newCart = Cart(
          customer: data,
          basketDetails: [BasketDetails(product: product, quantity: 1)],
          totalPrice: product.price);
      CartManagementService.updateCart(newCart).then((value) {
        cart = value.values.toList()[0];
        cartStream.add(cart);
      });
    }
  }
}
