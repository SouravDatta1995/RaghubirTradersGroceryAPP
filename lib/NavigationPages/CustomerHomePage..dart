import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Product.dart';
import 'package:raghuvir_traders/Elements/UserData.dart';
import 'package:raghuvir_traders/Elements/UserLogin.dart';
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
  bool _searchFlag;
  @override
  void initState() {
    _sortVal = 0;
    _categoryVal = 0;
    _products = ProductManagementService.getProducts();
    _searchFlag = false;
    super.initState();
  }

  @override
  void dispose() {
    AppDataBLoC().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
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
                          onChanged: (value){
                            setState(() {
                              _products=ProductManagementService.findProducts(value);
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
                                  _products = ProductManagementService.getProducts();
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
                      stream: AppDataBLoC().cartNum.stream,
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
      ),
      drawer: Drawer(
        child: _drawerWidget(),
      ),
      body: RefreshIndicator(
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
                    _categoryList(),
                    _sortList(),
                  ],
                ),
              ),
            ),
            FutureBuilder<List<Product>>(
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
                }),
          ],
        ),
      ),
    );
  }

  Widget _categoryList() {
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

  Widget _sortList() {
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
          child: Placeholder(),
        ),
        Expanded(
          child: GestureDetector(
            excludeFromSemantics: false,
            onTap: () {
              AppDataBLoC().dispose();
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
}
