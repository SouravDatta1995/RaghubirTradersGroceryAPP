import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/Elements/Product.dart';

class ProductItem extends StatefulWidget {
  final Product product;

  const ProductItem({Key key, this.product}) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  void initState() {
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
                  child: widget.product.logo == ("default")
                      ? Image.asset(
                          "assets/apple.png",
                          height: 40,
                          width: 40,
                          fit: BoxFit.fill,
                        )
                      : Image.memory(
                          base64Decode(widget.product.logo),
                          height: 80,
                          width: 80,
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
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            widget.product.name,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: AppDataBLoC.primaryColor),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            AppDataBLoC.categoryList[
                                int.parse(widget.product.category)],
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black45),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Rs. " + widget.product.price.toString(),
                                style: TextStyle(
                                    color: AppDataBLoC.primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                                child: ProductItemButtonBuilder(
                              product: widget.product,
                            )),
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
}

class ProductItemButtonBuilder extends StatefulWidget {
  final Product product;

  const ProductItemButtonBuilder({Key key, this.product}) : super(key: key);
  @override
  _ProductItemButtonBuilderState createState() =>
      _ProductItemButtonBuilderState();
}

class _ProductItemButtonBuilderState extends State<ProductItemButtonBuilder> {
  int _itemNum;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Cart>(
      stream: AppDataBLoC.appDataBLoC.cartStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          BasketDetails b = snapshot.data.basketDetails.firstWhere(
              (element) =>
                  element.product.productId == widget.product.productId,
              orElse: () => null);
          _itemNum = b != null ? b.quantity : 0;
          return _itemButton();
        }
        return Container();
      },
    );
  }

  Widget _itemButton() {
    return _itemNum == 0
        ? RaisedButton(
            color: AppDataBLoC.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            onPressed: () {
              setState(() {
                ++_itemNum;
                AppDataBLoC.appDataBLoC.cartNumAdd(widget.product, _itemNum);
              });
            },
            child: Text(
              "Add",
              style: TextStyle(color: AppDataBLoC.secondaryColor),
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

                      AppDataBLoC.appDataBLoC
                          .cartNumAdd(widget.product, _itemNum);
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
                      color: AppDataBLoC.secondaryColor,
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
                      _itemNum.toString(),
                      style: TextStyle(
                          color: AppDataBLoC.primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      ++_itemNum;
                      AppDataBLoC.appDataBLoC
                          .cartNumAdd(widget.product, _itemNum);
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
                      color: AppDataBLoC.secondaryColor,
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
