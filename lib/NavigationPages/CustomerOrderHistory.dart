import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/NavigationPages/CustomerHomePage..dart';
import 'package:raghuvir_traders/Services/ApplicationUrlService.dart';
import 'package:raghuvir_traders/Services/OrderHistoryService.dart';
import 'package:raghuvir_traders/Widgets/DrawerWidget.dart';

class CustomerOrderHistory extends StatefulWidget {
  static String id = "CustomerOrderHistory";
  @override
  _CustomerOrderHistoryState createState() => _CustomerOrderHistoryState();
}

class _CustomerOrderHistoryState extends State<CustomerOrderHistory> {
  ScrollController _scrollController =
      ScrollController(); // set controller on scrolling
  bool _show = true;

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          if (_show == true) _show = false;
        });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          if (_show == false) _show = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    handleScroll();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppDataBLoC.primaryColor,
        actionsIconTheme: IconThemeData(color: AppDataBLoC.secondaryColor),
        iconTheme: IconThemeData(color: AppDataBLoC.secondaryColor),
        title: Text(
          "Order History",
          style: TextStyle(color: AppDataBLoC.secondaryColor),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Visibility(
        visible: _show,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "phoneIcon",
              onPressed: () {
                ApplicationUrlService.launchPhone();
              },
              child: Icon(MdiIcons.phone),
            ),
            SizedBox(
              width: 16.0,
            ),
            FloatingActionButton(
              heroTag: "waIcon",
              onPressed: () {
                ApplicationUrlService.launchWhatsApp();
              },
              child: Icon(MdiIcons.whatsapp),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Cart>>(
        future: OrderHistoryService.getLastOrder(AppDataBLoC.data.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0)
              return ListView.builder(
                controller: _scrollController,
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
                            style: TextStyle(color: AppDataBLoC.primaryColor),
                          ),
                          Text(
                            "Total : " + c.totalPrice.toString(),
                            style: TextStyle(color: AppDataBLoC.primaryColor),
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
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppDataBLoC.primaryColor),
                ),
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
