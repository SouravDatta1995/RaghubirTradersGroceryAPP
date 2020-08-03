import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Product.dart';

class ProductItem extends StatefulWidget {
  final Product product;

  const ProductItem({Key key, this.product}) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int _itemNum;

  @override
  void initState() {
    _itemNum = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      //contentPadding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.product.logo,
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 12.0),
                        child: Text(
                          widget.product.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                widget.product.price.toString(),
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                            Expanded(child: _itemButton()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemButton() {
    return _itemNum == 0
        ? RaisedButton(
            color: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            onPressed: () {
              setState(() {
                ++_itemNum;

                AppDataBLoC().cartNumAdd(1);
              });
            },
            child: Text(
              "Add",
              style: TextStyle(color: Colors.white),
            ),
          )
        : Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      --_itemNum;
                      AppDataBLoC().cartNumAdd(-1);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black87,
                          blurRadius: 2.0,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Center(
                      child: Icon(
                        MdiIcons.minus,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _itemNum.toString() + " kg",
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      ++_itemNum;
                      AppDataBLoC().cartNumAdd(1);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black87,
                          blurRadius: 2.0,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Center(
                      child: Icon(
                        MdiIcons.plus,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
