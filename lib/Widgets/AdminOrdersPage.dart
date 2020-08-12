import 'package:flutter/material.dart';
import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/Services/OrderHistoryService.dart';

class AdminOrdersPage extends StatefulWidget {
  @override
  _AdminOrdersPageState createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cart>>(
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
                listItems.add(RaisedButton(
                  onPressed: () {},
                  child: Text("Complete Order"),
                  textColor: Colors.white,
                  color: Colors.green,
                ));
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Card(
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.all(16.0),
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
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Padding customerDetailsWidget(Cart c) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Name",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                c.customer.name,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Phone No.",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                c.customer.phoneNumber.toString(),
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Address",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                c.customer.address,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
