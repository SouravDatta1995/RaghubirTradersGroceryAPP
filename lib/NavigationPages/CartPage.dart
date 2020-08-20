import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/NavigationPages/CustomerHomePage..dart';
import 'package:raghuvir_traders/NavigationPages/OrderPage.dart';
import 'package:raghuvir_traders/Widgets/CartItem.dart';
import 'package:raghuvir_traders/Widgets/DrawerWidget.dart';

class CartPage extends StatefulWidget {
  static String id = "CartPage";
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<BasketDetails> _products;
  @override
  void initState() {
    AppDataBLoC.appDataBLoC.cartStream.stream.listen((event) {
      if (mounted)
        setState(() {
          _products = event.basketDetails
              .where((element) => element.quantity > 0)
              .toList();
          _products.sort(
              (a, b) => a.product.productId.compareTo(b.product.productId));
        });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _cartAppBar(),
      drawer: DrawerWidget(
        currentPage: "Cart",
      ),
      body: _cartBody(),
    );
  }

  Widget _cartAppBar() {
    return AppBar(
      backgroundColor: AppDataBLoC.primaryColor,
      elevation: 4.0,
      iconTheme: IconThemeData(color: AppDataBLoC.secondaryColor),
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  "Cart",
                  style: TextStyle(color: AppDataBLoC.secondaryColor),
                ),
              ),
            ),
            GestureDetector(
              excludeFromSemantics: false,
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, CustomerHomePage.id, (route) => false),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  MdiIcons.close,
                  color: AppDataBLoC.secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartBody() {
    return _products == null
        ? Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppDataBLoC.primaryColor),
            ),
          )
        : _products.length > 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        //print(b[index].product.logo);
                        return CartItem(
                          product: _products[index].product,
                        );
                      },
                      itemCount: _products.length,
                    ),
                  ),
                  GestureDetector(
                    excludeFromSemantics: false,
                    onTap: () {
                      AppDataBLoC.appDataBLoC.cartUpdate();
                      Navigator.pushNamed(context, OrderPage.id);
                    },
                    child: Container(
                      color: AppDataBLoC.primaryColor,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Tap to order",
                                style: TextStyle(
                                    color: AppDataBLoC.secondaryColor),
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder<Cart>(
                                stream:
                                    AppDataBLoC.appDataBLoC.cartStream.stream,
                                builder: (context, snapshot) => snapshot.hasData
                                    ? Text(
                                        "Rs. " +
                                            snapshot.data.totalPrice.toString(),
                                        style: TextStyle(
                                          color: AppDataBLoC.secondaryColor,
                                        ),
                                        textAlign: TextAlign.right,
                                      )
                                    : Container(),
                              ),
                            ),
                            Icon(
                              MdiIcons.arrowRight,
                              size: 20.0,
                              color: AppDataBLoC.secondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  "No items in the Cart",
                  style: TextStyle(color: Colors.black45),
                ),
              );
  }
}
