import 'package:flutter/material.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/Services/OrderHistoryService.dart';

class AdminOrdersPage extends StatefulWidget {
  @override
  _AdminOrdersPageState createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder<List<Cart>>(
        future: OrderHistoryService.getPendingOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0)
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Cart c = snapshot.data[index];
                  List<Widget> listItems = [
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Name",
                              textAlign: TextAlign.center,
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Price",
                              textAlign: TextAlign.center,
                            )),
                        Expanded(
                            child: Text(
                          "Quantity",
                          textAlign: TextAlign.center,
                        )),
                      ],
                    ),
                    Divider(),
                  ];
                  c.basketDetails.forEach((element) {
                    if (element.quantity > 0)
                      listItems.add(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    element.product.name,
                                    textAlign: TextAlign.center,
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    element.product.price.toString(),
                                    textAlign: TextAlign.center,
                                  )),
                              Expanded(
                                  child: Text(
                                element.quantity.toString(),
                                textAlign: TextAlign.center,
                              )),
                            ],
                          ),
                        ),
                      );
                  });
                  listItems.add(SizedBox(
                    height: 8.0,
                  ));
                  listItems.add(Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          c.paymentMode,
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            OrderHistoryService.updateBasketDelivery(
                                    userId: c.customer.id, basketId: c.basketId)
                                .then((value) {
                              if (value == "Success") {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Delivery status updated"),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                                setState(() {});
                              } else
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Error updating delivery status"),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                            });
                          },
                          child: Text("Complete Order"),
                          textColor: AppDataBLoC.secondaryColor,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ));
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Card(
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.all(8.0),
                        title: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Basket Id : " + c.basketId.toString(),
                                ),
                                Text(
                                  "Total : " + c.totalPrice.toString(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        children: listItems,
                        childrenPadding: EdgeInsets.all(16.0),
                        subtitle: customerDetailsWidget(c),
                      ),
                    ),
                  );
                },
              );
            return Center(
              child: Text("No Pending Orders "),
            );
          } else {
            return Center(
              child: Container(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppDataBLoC.primaryColor),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Padding customerDetailsWidget(Cart c) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Name",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    c.customer.name,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Phone No.",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    c.customer.phoneNumber.toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Delivery Address",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    c.deliveryAddress,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
