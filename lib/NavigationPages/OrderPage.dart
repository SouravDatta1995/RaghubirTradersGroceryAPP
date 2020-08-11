import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/Services/CartManagementService.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderPage extends StatefulWidget {
  static String id = "Order";
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  double _total;
  void launchWhatsApp({String phone, String message}) async {
    String url() {
      return "whatsapp://send?phone=$phone";
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  void launchPhone({String phoneNumber}) async {
    String url() {
      return "tel:$phoneNumber";
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  @override
  void initState() {
    _total = AppDataBLoC.cart.totalPrice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                totalCard(),
                SizedBox(
                  height: 16.0,
                ),
                userDetailsCard(),
                SizedBox(
                  height: 16.0,
                ),
                OrderDetailsCard(),
                SizedBox(
                  height: 16.0,
                ),
                PaymentSelectorCard(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 80.0),
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  launchWhatsApp(phone: "+919477014134");
                },
                child: Icon(MdiIcons.whatsapp),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  launchPhone(phoneNumber: "+91 94770 14134");
                },
                child: Icon(MdiIcons.phone),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card userDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("Name"),
                ),
                Expanded(
                  flex: 3,
                  child: Text(AppDataBLoC.data.name),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("Phone"),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    AppDataBLoC.data.phoneNumber.toString(),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("Address"),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    AppDataBLoC.data.address ?? "Default",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card totalCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Order Total",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Rs. " + _total.toString(),
              style: TextStyle(fontSize: 20.0),
            )
          ],
        ),
      ),
    );
  }
}

class OrderDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: CartManagementService.getLastCart(AppDataBLoC.data.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Container(
                  height: 30.0,
                  width: 30.0,
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              Cart c = snapshot.data.values.toList()[0];
              List<BasketDetails> b = c.basketDetails
                  .where((element) => element.quantity > 0)
                  .toList();
              b.sort((a, b) => a.quantity.compareTo(b.quantity));
              return Column(
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: b.length,
                    itemBuilder: (context, index) {
                      double price = b[index].product.price * b[index].quantity;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Text(
                                b[index].product.name,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      b[index].product.price.toString(),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Expanded(
                                    child: Icon(
                                      MdiIcons.close,
                                      size: 12.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      b[index].quantity.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Icon(
                                      MdiIcons.equal,
                                      size: 12.0,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      price.toString(),
                                      textAlign: TextAlign.right,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Total",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        c.totalPrice.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class PaymentSelectorCard extends StatefulWidget {
  @override
  _PaymentSelectorCardState createState() => _PaymentSelectorCardState();
}

class _PaymentSelectorCardState extends State<PaymentSelectorCard> {
  int _paymentSelectorIndex;
  @override
  void initState() {
    _paymentSelectorIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Payment",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ChoiceChip(
                      label: Text("Cash on Delivery"),
                      labelStyle: TextStyle(
                        color: _paymentSelectorIndex == 1
                            ? Colors.white
                            : Colors.black,
                      ),
                      autofocus: true,
                      selectedColor: Colors.blue,
                      selected: _paymentSelectorIndex == 1,
                      onSelected: (value) {
                        setState(() {
                          _paymentSelectorIndex = value ? 1 : 0;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: Text("Online Payment(RazorPay)"),
                      labelStyle: TextStyle(
                        color: _paymentSelectorIndex == 2
                            ? Colors.white
                            : Colors.black,
                      ),
                      selectedColor: Colors.blue,
                      selected: _paymentSelectorIndex == 2,
                      onSelected: (value) {
                        setState(() {
                          _paymentSelectorIndex = value ? 2 : 0;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: _paymentSelectorIndex == 0 ? null : () {},
            child: Text("Continue"),
          ),
        ),
      ],
    );
  }
}
