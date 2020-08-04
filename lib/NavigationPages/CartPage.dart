import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/NavigationPages/CustomerHomePage..dart';
import 'package:raghuvir_traders/Widgets/DrawerWidget.dart';
import 'package:raghuvir_traders/Widgets/ProductItem.dart';

class CartPage extends StatefulWidget {
  static String id = "CartPage";
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _cartAppBar(),
      drawer: DrawerWidget(),
      body: _cartBody(),
    );
    ;
  }

  Widget _cartAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4.0,
      iconTheme: IconThemeData(color: Colors.black),
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  "Cart",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Icon(
              MdiIcons.nullIcon,
              color: Colors.white,
            ),
            GestureDetector(
              onTap: () => Navigator.popUntil(
                  context, ModalRoute.withName(CustomerHomePage.id)),
              child: Icon(
                MdiIcons.close,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartBody() {
    return StreamBuilder<Cart>(
      stream: AppDataBLoC.appDataBLoC.cartStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Cart c = snapshot.data;
          List<BasketDetails> b =
              c.basketDetails.where((element) => element.quantity > 0).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    //print(b[index].product.logo);
                    return ProductItem(
                      quantity: b[index].quantity,
                      product: b[index].product,
                    );
                  },
                  itemCount: b.length,
                ),
              ),
              Container(
                color: Colors.blueAccent,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Tap to order",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Rs. " + snapshot.data.totalPrice.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Icon(
                        MdiIcons.arrowRight,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Container(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
