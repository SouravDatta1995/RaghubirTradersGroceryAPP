import 'package:flutter/material.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/UserLogin.dart';
import 'package:raghuvir_traders/NavigationPages/AboutPage.dart';
import 'package:raghuvir_traders/NavigationPages/CartPage.dart';
import 'package:raghuvir_traders/NavigationPages/CustomerHomePage..dart';
import 'package:raghuvir_traders/NavigationPages/CustomerOrderHistory.dart';

class DrawerWidget extends StatefulWidget {
  final String currentPage;

  const DrawerWidget({Key key, this.currentPage}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              child: Stack(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "R",
                                style: TextStyle(
                                    fontSize: 48, color: Colors.white),
                              ),
                              Text(
                                "\nT",
                                style: TextStyle(
                                    fontSize: 48, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                    color: Colors.blueAccent,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          AppDataBLoC.data.name,
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          AppDataBLoC.data.phoneNumber.toString(),
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text("Products"),
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.currentPage != "Products")
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        CustomerHomePage.id,
                        (route) => false,
                      );
                  },
                ),
                ListTile(
                  title: Text("Cart"),
                  onTap: () {
                    setState(() {
                      Navigator.pop(context);
                      if (widget.currentPage != "Cart") {
                        Navigator.pushNamed(context, CartPage.id);
                      }
                    });
                  },
                ),
                ListTile(
                  title: Text("Orders"),
                  onTap: () {
                    setState(() {
                      Navigator.pop(context);
                      if (widget.currentPage != "Order") {
                        Navigator.pushNamed(context, CustomerOrderHistory.id);
                      }
                    });
                  },
                ),
                ListTile(
                  title: Text("About this app"),
                  onTap: () {
                    setState(() {
                      Navigator.pushNamed(context, AboutPage.id);
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Powered by : Mukherjee Solutions"),
                Text("Contact : 7059249929"),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              excludeFromSemantics: false,
              onTap: () {
//              AppDataBLoC.appDataBLoC.dispose();
                UserLogin.setCachePhoneNumber(0);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              child: Container(
                color: Colors.blueAccent,
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
