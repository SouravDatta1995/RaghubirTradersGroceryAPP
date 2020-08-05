import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/Elements/Product.dart';
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
  bool _searchFlag = false;
  AppDataBLoC _bLoC;
  @override
  void initState() {
    _sortVal = 0;
    _categoryVal = 0;

    _searchFlag = false;
    CartManagementService.getLastCart(AppDataBLoC.data.id).then((value) {
      Cart c = value.values.toList()[0];
      _bLoC = AppDataBLoC(AppDataBLoC.data, c.basketId);
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
    _products = ProductManagementService.getProducts();
    return Scaffold(
      appBar: _productAppBar(),
      drawer: DrawerWidget(
        currentPage: "Products",
      ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
                });
              },
              child: _searchFlag
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        MdiIcons.magnify,
                        color: Colors.black,
                      ),
                    ),
            ),
            GestureDetector(
              excludeFromSemantics: false,
              onTap: () => Navigator.pushNamed(context, CartPage.id),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
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
                                    shape: BoxShape.circle, color: Colors.red),
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
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ProductItem(
                    product: snapshot.data[index],
                  );
                },
                childCount: snapshot.data.length,
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
    List<DropdownMenuItem> _categories = [
      DropdownMenuItem(
        child: Text("View All"),
        value: 0,
      ),
      DropdownMenuItem(
        child: Text("Fruits & Vegetables"),
        value: 1,
      ),
      DropdownMenuItem(
        child: Text("Foodgrains, Oil & Masala "),
        value: 2,
      ),
      DropdownMenuItem(
        child: Text("Bakery, Cakes & Dairy"),
        value: 3,
      ),
      DropdownMenuItem(
        child: Text("Bakery, Cakes & Dairy"),
        value: 3,
      ),
      DropdownMenuItem(
        child: Text("Beverages"),
        value: 4,
      ),
      DropdownMenuItem(
        child: Text("Snacks & Branded Foods"),
        value: 5,
      ),
      DropdownMenuItem(
        child: Text("Beauty & Hygiene"),
        value: 6,
      ),
      DropdownMenuItem(
        child: Text("Cleaning & Household"),
        value: 7,
      ),
      DropdownMenuItem(
        child: Text("Kitchen, Garden & Pets"),
        value: 8,
      ),
      DropdownMenuItem(
        child: Text("Eggs,Meat & Fish"),
        value: 9,
      ),
      DropdownMenuItem(
        child: Text("Gourmet & World Food"),
        value: 10,
      ),
      DropdownMenuItem(
        child: Text("Baby Care"),
        value: 11,
      ),
    ];

    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            style: TextStyle(fontSize: 14.0, color: Colors.black),
            isExpanded: true,
            value: _categoryVal,
            onChanged: (value) {
              setState(() {
                _categoryVal = value;
              });
            },
            items: _categories,
          ),
        ),
      ),
    );
  }

  Widget _sortListWidget() {
    return Expanded(
      flex: 2,
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
            style: TextStyle(fontSize: 14.0, color: Colors.black),
            isExpanded: true,
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
