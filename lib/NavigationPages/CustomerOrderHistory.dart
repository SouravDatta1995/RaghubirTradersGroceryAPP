import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/NavigationPages/CustomerHomePage..dart';
import 'package:raghuvir_traders/Services/OrderHistoryService.dart';
import 'package:raghuvir_traders/Widgets/DrawerWidget.dart';

class CustomerOrderHistory extends StatefulWidget {
  static String id = "CustomerOrderHistory";
  @override
  _CustomerOrderHistoryState createState() => _CustomerOrderHistoryState();
}

class _CustomerOrderHistoryState extends State<CustomerOrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Order History",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          GestureDetector(
            excludeFromSemantics: false,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, CustomerHomePage.id, (route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(MdiIcons.close),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Cart>>(
        future: OrderHistoryService.getLastOrder(AppDataBLoC.data.id),
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
                  return Card(
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.all(16.0),
                      title: Row(
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
                      children: listItems,
                      childrenPadding: EdgeInsets.all(16.0),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              c.isDelivered ? "Delivered" : "On the Way",
                              style: TextStyle(
                                color: c.isDelivered
                                    ? Colors.green
                                    : Colors.deepOrangeAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            else
              return Center(
                child: Text("No Available Orders "),
              );
          } else {
            return Center(
              child: Container(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      drawer: DrawerWidget(
        currentPage: "Order",
      ),
    );
  }
}
