import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/Elements/Product.dart';
import 'package:raghuvir_traders/Elements/UserData.dart';
import 'package:raghuvir_traders/Services/CartManagementService.dart';
import 'package:raghuvir_traders/Services/ProductManagementService.dart';
import 'package:raghuvir_traders/Widgets/DrawerWidget.dart';
import 'package:raghuvir_traders/Widgets/ProductItem.dart';

import 'CartPage.dart';

class CustomerHomePage extends StatefulWidget {
  static String id = 'CustomerProductOverView';
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _sortVal, _categoryVal;
  Future<List<Product>> _products;
  UserData _user;
  bool _searchFlag = false;
  List<AppBar> _appBarList = [];
  AppDataBLoC _bLoC;
  @override
  void initState() {
    _sortVal = 0;
    _categoryVal = 0;
    _products = ProductManagementService.getProducts();
    _searchFlag = false;
    CartManagementService.getLastCart(AppDataBLoC.data.id).then((value) {
      Cart c = value.values.toList()[0];
      _bLoC = AppDataBLoC(_user, c.basketId);
      int count = 0;
      AppDataBLoC.cart = c;
      AppDataBLoC.appDataBLoC.cartStream.add(c);
      if (AppDataBLoC.basketId != 0) {
        AppDataBLoC.cart.basketDetails.forEach((element) {
          count += element.quantity;
        });
      }
      AppDataBLoC.appDataBLoC.cartNum.add(count);
    });
    super.initState();
  }

  @override
  void dispose() {
//    AppDataBLoC.appDataBLoC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: _productAppBar(),
      drawer: DrawerWidget(),
      body: _productBody(),
    );
  }

  Widget _productBody() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _products = ProductManagementService.getProducts();
        });
      },
      displacement: 20.0,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            floating: true,
            primary: false,
            title: Center(
              child: Row(
                children: <Widget>[
                  _categoryListWidget(),
                  _sortListWidget(),
                ],
              ),
            ),
          ),
          _productListWidget(),
        ],
      ),
    );
  }

  Widget _productAppBar() {
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
                child: _searchFlag
                    ? TextField(
                        onChanged: (value) {
                          setState(() {
                            _products =
                                ProductManagementService.findProducts(value);
                          });
                        },
                        autofocus: true,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Product Name",
                          border: InputBorder.none,
                          suffixIcon: GestureDetector(
                            excludeFromSemantics: false,
                            onTap: () {
                              setState(() {
                                _products =
                                    ProductManagementService.getProducts();
                                _searchFlag = false;
                              });
                            },
                            child: Icon(
                              MdiIcons.close,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    : Text(
                        "Products",
                        style: TextStyle(color: Colors.black),
                      ),
              ),
            ),
            GestureDetector(
              excludeFromSemantics: false,
              onTap: () {
                setState(() {
                  _searchFlag = true;
                  _appBarList[0] = _productAppBar();
                });
              },
              child: _searchFlag
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        MdiIcons.magnify,
                        color: Colors.black,
                      ),
                    ),
            ),
            GestureDetector(
              excludeFromSemantics: false,
              onTap: () => Navigator.pushNamed(context, CartPage.id),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      MdiIcons.cart,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    left: 20.0,
                    child: StreamBuilder(
                      stream: AppDataBLoC.appDataBLoC.cartNum.stream,
                      builder: (context, snapshot) => snapshot.data != 0
                          ? Container(
                              height: 12.0,
                              width: 12.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productListWidget() {
    return FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<Cart>(
              stream: AppDataBLoC.appDataBLoC.cartStream.stream,
              builder: (context, snapshot2) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (snapshot2.hasData) {
                      BasketDetails b = BasketDetails();
                      if (AppDataBLoC.basketId != 0) {
                        b = snapshot2.data.basketDetails.firstWhere(
                            (element) =>
                                element.product.productId ==
                                snapshot.data[index].productId,
                            orElse: () => null);
                      }

                      int quantity = b != null ? b.quantity : 0;
                      return ProductItem(
                        product: snapshot.data[index],
                        quantity: quantity ?? 0,
                      );
                    } else
                      return Container();
                  },
                  childCount: snapshot.data.length,
                ),
              ),
            );
          } else {
            return SliverFillRemaining(
              child: Center(
                child: Container(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }

  Widget _categoryListWidget() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: _categoryVal,
            onChanged: (value) {
              setState(() {
                _categoryVal = value;
              });
            },
            items: [
              DropdownMenuItem(
                child: Text("No Category"),
                value: 0,
              ),
              DropdownMenuItem(
                child: Text("Vegetables"),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text("Fruits"),
                value: 2,
              ),
              DropdownMenuItem(
                child: Text("Spices"),
                value: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sortListWidget() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            onChanged: (value) {
              setState(() {
                _sortVal = value;
              });
            },
            icon: Icon(MdiIcons.sortVariant),
            value: _sortVal,
            items: [
              DropdownMenuItem(
                child: Text("No Sort"),
                value: 0,
              ),
              DropdownMenuItem(
                child: Text("A-Z"),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text("Z-A"),
                value: 2,
              ),
              DropdownMenuItem(
                child: Text("Price High-Low"),
                value: 3,
              ),
              DropdownMenuItem(
                child: Text("Price Low-High"),
                value: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
