import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/Product.dart';
import 'package:raghuvir_traders/Services/ProductManagementService.dart';
import 'package:raghuvir_traders/Widgets/AdminAddProductWidget.dart';

class AdminProductPage extends StatefulWidget {
  @override
  _AdminProductPageState createState() => _AdminProductPageState();
}

class _AdminProductPageState extends State<AdminProductPage> {
  List<Product> products = [];
  Future<List<Product>> _productsFuture;
  int _itemLength;

  @override
  void initState() {
    _productsFuture = ProductManagementService.getProducts();
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          onChanged: (value) {},
                          items: [
                            DropdownMenuItem(
                              child: Text("Vegetables"),
                            ),
                            DropdownMenuItem(
                              child: Text("Fruits"),
                            ),
                            DropdownMenuItem(
                              child: Text("Spices"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          onChanged: (value) {},
                          icon: Icon(MdiIcons.sortVariant),
                          items: [
                            DropdownMenuItem(
                              child: Text("Popularity"),
                            ),
                            DropdownMenuItem(
                              child: Text("A-Z"),
                            ),
                            DropdownMenuItem(
                              child: Text("Z-A"),
                            ),
                            DropdownMenuItem(
                              child: Text("Price High-Low"),
                            ),
                            DropdownMenuItem(
                              child: Text("Price Low-High"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
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
                        return AdminProducts(
                          product: products[index - 1],
                        );
                      else
                        return GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => AdminAddProductWidget(),
                              isScrollControlled: true,
                              useRootNavigator: true,
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
}

class AdminProducts extends StatefulWidget {
  final Product product;

  AdminProducts({this.product});

  @override
  _AdminProductsState createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  @override
  Widget build(BuildContext context) {
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
                child: CachedNetworkImage(
                  imageUrl: widget.product.logo,
                  height: 40,
                  width: 40,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  widget.product.name,
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child:
                  Center(child: Text("Rs." + widget.product.price.toString())),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("EDIT"),
                ),
                PopupMenuItem(
                  child: Text("DELETE"),
                ),
                PopupMenuItem(
                  child: Text("DISABLE"),
                ),
              ],
            )
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
