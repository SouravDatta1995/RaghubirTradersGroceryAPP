import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AdminProductPage extends StatefulWidget {
  @override
  _AdminProductPageState createState() => _AdminProductPageState();
}

class _AdminProductPageState extends State<AdminProductPage> {
  int _itemLength = 4;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < _itemLength - 1)
                return AdminProducts();
              else
                return AddItem();
            },
            childCount: _itemLength,
          ),
        )
      ],
    );
    ;
  }
}

class AdminProducts extends StatefulWidget {
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
                  imageUrl:
                      "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?ixlib=rb-1.2.1&w=1000&q=80",
                  height: 40,
                  width: 40,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Center(child: Text("Price : Rs.80")),
            ),
            Expanded(
              child: Center(child: Text("Qty : 20Kg")),
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
