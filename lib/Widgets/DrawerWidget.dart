import 'package:flutter/material.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/UserLogin.dart';
import 'package:raghuvir_traders/NavigationPages/CartPage.dart';
import 'package:raghuvir_traders/NavigationPages/CustomerHomePage..dart';

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
            flex: 8,
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text("Products"),
                  onTap: () {
                    if (widget.currentPage == "Products")
                      Navigator.pop(context);
                    else
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        CustomerHomePage.id,
                        ModalRoute.withName(CustomerHomePage.id),
                      );
                  },
                ),
                ListTile(
                  title: Text("Cart"),
                  onTap: () {
                    setState(() {
                      if (widget.currentPage == "Cart")
                        Navigator.pop(context);
                      else
                        Navigator.pushNamed(context, CartPage.id);
                    });
                  },
                ),
                ListTile(
                  title: Text("Orders"),
                  onTap: () {
                    setState(() {});
                  },
                ),
                ListTile(
                  title: Text("About us"),
                  onTap: () {
                    setState(() {});
                  },
                ),
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
                    context, '/', ModalRoute.withName("/"));
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
