import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/Elements/Product.dart';
import 'package:raghuvir_traders/Elements/UserData.dart';
import 'package:raghuvir_traders/Elements/UserLogin.dart';
import 'package:raghuvir_traders/Services/CartManagementService.dart';
import 'package:raghuvir_traders/Services/ProductManagementService.dart';
import 'package:raghuvir_traders/Widgets/ProductItem.dart';

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
  int _index;
  List<AppBar> _appBarList = [];
  List<Widget> _bodyList = [];
  AppDataBLoC _bLoC;
  @override
  void initState() {
    _sortVal = 0;
    _categoryVal = 0;
    _products = ProductManagementService.getProducts();
    _searchFlag = false;
    _index = 0;
    _appBarList = [
      _productAppBar(),
      _cartAppBar(),
    ];
    _bodyList = [
      _productBody(),
      _cartBody(),
    ];
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
      appBar: _appBarList[_index],
      drawer: Drawer(
        child: _drawerWidget(),
      ),
      body: _bodyList[_index],
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
            Stack(
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
            return FutureBuilder<Map<String, dynamic>>(
              future: CartManagementService.getLastCart(_user.id),
              builder: (context, snapshot1) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (snapshot1.hasData) {
                        Cart c = snapshot1.data.values.toList()[0];
                        _bLoC = AppDataBLoC(_user, c.basketId);
                        int count = 0;
                        BasketDetails b = BasketDetails();
                        if (c.basketId != 0) {
                          c.basketDetails.forEach((element) {
                            count += element.quantity;
                          });
                          b = c.basketDetails.firstWhere(
                              (element) =>
                                  element.product.productId ==
                                  snapshot.data[index].productId,
                              orElse: () => null);
                        }

                        AppDataBLoC.appDataBLoC.cartNum.add(count);
                        AppDataBLoC.cart = c;
                        AppDataBLoC.appDataBLoC.cartStream.add(c);

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
                );
              },
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

  Widget _drawerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(
            child: Stack(
              children: [
                Container(
                  color: Colors.blueAccent,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        _user.name,
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        _user.phoneNumber.toString(),
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text("Products"),
                onTap: () {
                  setState(() {
                    _index = 0;
                  });
                },
              ),
              ListTile(
                title: Text("Cart"),
                onTap: () {
                  setState(() {
                    _index = 1;
                  });
                },
              ),
              ListTile(
                title: Text("Orders"),
                onTap: () {
                  setState(() {
                    _index = 2;
                  });
                },
              ),
              ListTile(
                title: Text("About us"),
                onTap: () {
                  setState(() {
                    _index = 3;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            excludeFromSemantics: false,
            onTap: () {
//              AppDataBLoC.appDataBLoC.dispose();
              UserLogin.setCachePhoneNumber(0);
              Navigator.pushNamedAndRemoveUntil(
                  context, "/", ModalRoute.withName("/"));
            },
            child: Container(
              color: Colors.blueAccent,
              child: Center(
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
            Icon(
              MdiIcons.nullIcon,
              color: Colors.white,
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
                    print(b[index].product.logo);
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
