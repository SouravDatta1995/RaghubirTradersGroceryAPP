import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Product.dart';
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
  List<String> _categoryList;
  @override
  void initState() {
    _sortVal = 0;
    _categoryVal = 0;
    _products = ProductManagementService.getProducts(_categoryVal, _sortVal);

    _categoryList = AppDataBLoC.categoryList;
    _searchFlag = false;
    super.initState();
  }

  @override
  void dispose() {
//    AppDataBLoC.appDataBLoC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          _products =
              ProductManagementService.getProducts(_categoryVal, _sortVal);
        });
      },
      displacement: 20.0,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: AppDataBLoC.secondaryColor,
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
      backgroundColor: AppDataBLoC.primaryColor,
      elevation: 4.0,
      iconTheme: IconThemeData(color: AppDataBLoC.secondaryColor),
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
                        style: TextStyle(color: AppDataBLoC.secondaryColor),
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: AppDataBLoC.primaryColor,
                        decoration: InputDecoration(
                          hintText: "Product Name",
                          hintStyle:
                              TextStyle(color: AppDataBLoC.secondaryColor),
                          border: InputBorder.none,
                          suffixIcon: GestureDetector(
                            excludeFromSemantics: false,
                            onTap: () {
                              setState(() {
                                _products =
                                    ProductManagementService.getProducts(
                                        _categoryVal, _sortVal);
                                _searchFlag = false;
                              });
                            },
                            child: Icon(
                              MdiIcons.close,
                              color: AppDataBLoC.secondaryColor,
                            ),
                          ),
                        ),
                      )
                    : Text(
                        "Products",
                        style: TextStyle(color: AppDataBLoC.secondaryColor),
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
                        color: AppDataBLoC.secondaryColor,
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
                        color: AppDataBLoC.secondaryColor,
                      ),
                    ),
                    Positioned(
                      left: 15.0,
                      child: StreamBuilder(
                        stream: AppDataBLoC.appDataBLoC.cartNum.stream,
                        builder: (context, snapshot) => snapshot.data != 0
                            ? Container(
                                height: 14.0,
                                width: 14.0,
                                child: Center(
                                  child: Text(snapshot.data.toString(),
                                      style: TextStyle(fontSize: 10.0)),
                                ),
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
                childCount: snapshot.data.length ?? 0,
              ),
            );
          } else {
            return SliverFillRemaining(
              child: Center(
                child: Container(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppDataBLoC.primaryColor),
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget _categoryListWidget() {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            style: TextStyle(fontSize: 14.0, color: AppDataBLoC.primaryColor),
            isExpanded: true,
            icon: Icon(
              MdiIcons.arrowDown,
              color: AppDataBLoC.primaryColor,
            ),
            value: _categoryVal,
            onChanged: (value) {
              setState(() {
                _categoryVal = value;
                _products = ProductManagementService.getProducts(
                    _categoryVal, _sortVal);
              });
            },
            items: List.generate(
              _categoryList.length,
              (index) => DropdownMenuItem(
                child: Text(
                  _categoryList[index],
                  style: TextStyle(color: AppDataBLoC.primaryColor),
                ),
                value: index,
              ),
            ),
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
                _products = ProductManagementService.getProducts(
                    _categoryVal, _sortVal);
              });
            },
            icon: Icon(
              MdiIcons.sortVariant,
              color: AppDataBLoC.primaryColor,
            ),
            value: _sortVal,
            style: TextStyle(fontSize: 14.0, color: AppDataBLoC.primaryColor),
            isExpanded: true,
            items: [
              DropdownMenuItem(
                child: Text(
                  "No Sort",
                  style: TextStyle(color: AppDataBLoC.primaryColor),
                ),
                value: 0,
              ),
              DropdownMenuItem(
                child: Text(
                  "A-Z",
                  style: TextStyle(color: AppDataBLoC.primaryColor),
                ),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text(
                  "Z-A",
                  style: TextStyle(color: AppDataBLoC.primaryColor),
                ),
                value: 3,
              ),
              DropdownMenuItem(
                child: Text(
                  "Price High-Low",
                  style: TextStyle(color: AppDataBLoC.primaryColor),
                ),
                value: 4,
              ),
              DropdownMenuItem(
                child: Text(
                  "Price Low-High",
                  style: TextStyle(color: AppDataBLoC.primaryColor),
                ),
                value: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
