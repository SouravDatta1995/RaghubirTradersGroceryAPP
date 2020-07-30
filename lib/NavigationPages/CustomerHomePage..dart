import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Widgets/ProductItem.dart';

class CustomerHomePage extends StatefulWidget {
  static String id = 'CustomerProductOverView';
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4.0,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.menu,
                color: Colors.black,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Products",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  MdiIcons.cart,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  MdiIcons.magnify,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: CustomScrollView(
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
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return ProductItem();
            }, childCount: 32),
          ),
        ],
      ),
    );
  }
}
