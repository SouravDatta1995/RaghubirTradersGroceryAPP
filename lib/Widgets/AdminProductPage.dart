import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/Product.dart';
import 'package:raghuvir_traders/Services/ProductManagementService.dart';
import 'package:raghuvir_traders/Widgets/AdminAddProductWidget.dart';
import 'package:raghuvir_traders/Widgets/AdminUpdateProductWidget.dart';

class AdminProductPage extends StatefulWidget {
  @override
  _AdminProductPageState createState() => _AdminProductPageState();
}

class _AdminProductPageState extends State<AdminProductPage> {
  List<Product> products = [];
  Future<List<Product>> _productsFuture;
  int _sortVal, _categoryVal;
  @override
  void initState() {
    _productsFuture = ProductManagementService.getProducts();
    _sortVal = 0;
    _categoryVal = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _productsFuture = ProductManagementService.getProducts();
        });
      },
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
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          onChanged: (value) {
                            setState(() {
                              _categoryVal = value;
                            });
                          },
                          value: _categoryVal,
                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                          isExpanded: true,
                          items: [
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
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
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SliverFillRemaining(
                  child: Center(
                    child: Container(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else {
                products = snapshot.data;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index > 0)
                        return _adminProducts(
                          product: products[index - 1],
                        );
                      else
                        return GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => AdminAddProductWidget(),
                              isScrollControlled: true,
                            ).then((value) {
                              setState(() {
                                _productsFuture =
                                    ProductManagementService.getProducts();
                              });
                            });
                          },
                          excludeFromSemantics: false,
                          child: AddItem(),
                        );
                    },
                    childCount: products.length + 1,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _adminProducts({Product product}) {
    return Card(
      elevation: 3.0,
      child: Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  bottomLeft: Radius.circular(4.0),
                ),
                color: Colors.green,
              ),
            ),
            Expanded(
              child: Center(
                child: product.logo.startsWith("http")
                    ? CachedNetworkImage(
                        imageUrl: product.logo,
                        height: 40,
                        width: 40,
                        fit: BoxFit.fill,
                      )
                    : Image.memory(
                        base64Decode(product.logo),
                        height: 40,
                        width: 40,
                      ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  product.name,
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(child: Text("Rs." + product.price.toString())),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Text("EDIT"),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text("DELETE"),
                ),
              ],
              onSelected: (value) {
                if (value == 0)
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => AdminUpdateProductWidget(
                      product: product,
                    ),
                    isScrollControlled: true,
                  ).then((value) {
                    setState(() {
                      _productsFuture = ProductManagementService.getProducts();
                    });
                  });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              MdiIcons.plusCircleOutline,
              color: Colors.grey,
            ),
            Text(
              " Add new Item",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
