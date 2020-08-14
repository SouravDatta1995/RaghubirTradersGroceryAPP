import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/Cart.dart';
import 'package:raghuvir_traders/Elements/RazorPayOptions.dart';
import 'package:raghuvir_traders/NavigationPages/CustomerOrderHistory.dart';
import 'package:raghuvir_traders/Services/CartManagementService.dart';
import 'package:raghuvir_traders/Services/OrderManagementService.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderPage extends StatefulWidget {
  static String id = "Order";
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  double _total;
  TextEditingController _textEditingController = TextEditingController();
  bool _sameAddress;
  @override
  void initState() {
    _textEditingController.text = AppDataBLoC.data.address;
    AppDataBLoC.deliveryAddress = AppDataBLoC.data.address;
    _sameAddress = true;
    _total = AppDataBLoC.cart.totalPrice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "Order",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          totalCard(),
          SizedBox(
            height: 8.0,
          ),
          userDetailsCard(),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: OrderDetailsCard(),
          ),
          SizedBox(
            height: 8.0,
          ),
          PaymentSelectorCard(),
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
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: TextField(
                      onChanged: (value) {
                        AppDataBLoC.deliveryAddress = value;
                      },
                      controller: _textEditingController,
                      enabled: !_sameAddress,
                      decoration:
                          InputDecoration(labelText: "Delivery Address"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: TextField(
                      onChanged: (value) {
                        AppDataBLoC.pin = int.parse(value);
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Pin Code"),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Checkbox(
                      value: _sameAddress,
                      onChanged: (value) {
                        setState(() {
                          _sameAddress = !_sameAddress;
                        });
                        if (value) {
                          _textEditingController.text =
                              AppDataBLoC.data.address;
                          AppDataBLoC.deliveryAddress =
                              AppDataBLoC.data.address;
                        } else {
                          _textEditingController.text = "";
                          AppDataBLoC.deliveryAddress = "";
                        }
                      },
                    ),
                    Text(
                      "Same as\nabove",
                      style: TextStyle(fontSize: 12.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
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
              ScrollController scrollController = ScrollController();
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Item List",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(),
                  Expanded(
                    flex: 8,
                    child: Scrollbar(
                      controller: scrollController,
                      isAlwaysShown: true,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: b.length,
                          itemBuilder: (context, index) {
                            double price =
                                b[index].product.price * b[index].quantity;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      b[index].product.name,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
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
                      ),
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: Row(
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
  Razorpay _razorPay;
  int _paymentSelectorIndex;
  @override
  void initState() {
    _paymentSelectorIndex = 0;
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    OrderManagementService.updatePayment(AppDataBLoC.cart.totalPrice,
            AppDataBLoC.cart.basketId, AppDataBLoC.data.id, "Online")
        .then((value) {
      if (value == "Success") {
        AppDataBLoC.setLastCart().then((value) =>
            Navigator.pushNamedAndRemoveUntil(
                context, CustomerOrderHistory.id, (route) => false));
      } else
        print("Error");
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Payment Failed"),
    ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    OrderManagementService.updatePayment(AppDataBLoC.cart.totalPrice,
            AppDataBLoC.cart.basketId, AppDataBLoC.data.id, response.walletName)
        .then((value) {
      if (value == "Success") {
        Navigator.pushNamedAndRemoveUntil(
            context, CustomerOrderHistory.id, (route) => false);
      } else
        print("Error");
    });
    print("Wallet");
  }

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
  void dispose() {
    _razorPay.clear();
    super.dispose();
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
                      label: Text("Online Payment"),
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
        ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              heroTag: null,
              label: Text("Continue Payment"),
              backgroundColor:
                  _paymentSelectorIndex == 0 ? Colors.grey : Colors.green,
              onPressed: _paymentSelectorIndex == 0
                  ? null
                  : _paymentSelectorIndex == 1
                      ? () {
                          //print("Pin: " + AppDataBLoC.pin.toString());
                          if (AppDataBLoC.deliveryAddress == "") {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Please Enter delivery address"),
                            ));
                          } else if (AppDataBLoC.pin == 0 ||
                              AppDataBLoC.pin == null) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Please Enter Pin Code"),
                            ));
                          } else if (AppDataBLoC.pin < 100000) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Pin Code not valid"),
                            ));
                          } else if (AppDataBLoC.pin != 700104 &&
                              AppDataBLoC.pin != 700063) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Area Not Deliverable"),
                            ));
                          } else {
                            OrderManagementService.initiateCheckout(
                                    AppDataBLoC.cart.totalPrice,
                                    AppDataBLoC.cart.basketId,
                                    AppDataBLoC.cart.customer.id,
                                    AppDataBLoC.deliveryAddress +
                                        " " +
                                        AppDataBLoC.pin.toString())
                                .then((value) {
                              if (value.keys.toList()[0] == "Success")
                                OrderManagementService.updatePayment(
                                        AppDataBLoC.cart.totalPrice,
                                        AppDataBLoC.cart.basketId,
                                        AppDataBLoC.data.id,
                                        "COD")
                                    .then((value) {
                                  if (value == "Success") {
                                    AppDataBLoC.setLastCart().then((value) =>
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            CustomerOrderHistory.id,
                                            (route) => false));
                                  } else
                                    print("Error");
                                });
                            });
                          }
                        }
                      : () {
                          if (AppDataBLoC.deliveryAddress == "") {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Please Enter delivery address"),
                            ));
                          } else if (AppDataBLoC.pin == 0 ||
                              AppDataBLoC.pin == null) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Please Enter Pin Code"),
                            ));
                          } else if (AppDataBLoC.pin < 100000) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Pin Code not valid"),
                            ));
                          } else if (AppDataBLoC.pin != 700104 &&
                              AppDataBLoC.pin != 700063) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Area Not Deliverable"),
                            ));
                          } else {
                            OrderManagementService.initiateCheckout(
                                    AppDataBLoC.cart.totalPrice,
                                    AppDataBLoC.cart.basketId,
                                    AppDataBLoC.cart.customer.id,
                                    AppDataBLoC.deliveryAddress +
                                        " " +
                                        AppDataBLoC.pin.toString())
                                .then((value) {
                              if (value.keys.toList()[0] == "Success") {
                                RazorPayOptions rpo = value.values.toList()[0];
                                print(rpo.amount.toString());
                                var options = {
                                  'key': 'rzp_test_pgmDCnUN2PTsMK',
                                  'amount': rpo.amount,
                                  //in the smallest currency sub-unit.
                                  'name': 'Raghuvir Traders',
                                  'order_id': rpo.id,
                                  // Generate order_id using Orders API
                                  'description': 'Order',
                                  'timeout': 300,
                                  // in seconds
                                  'prefill': {
                                    'name': AppDataBLoC.data.name,
                                    'contact':
                                        AppDataBLoC.data.phoneNumber.toString()
                                  }
                                };
                                _razorPay.open(options);
                              }
                            });
                          }
                        },
            ),
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                launchPhone(phoneNumber: "9477014134");
              },
              child: Icon(MdiIcons.phone),
              backgroundColor: Colors.blueAccent,
            ),
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                launchWhatsApp(phone: "+919477014134");
              },
              child: Icon(MdiIcons.whatsapp),
              backgroundColor: Colors.blueAccent,
            ),
          ],
        ),
      ],
    );
  }
}
