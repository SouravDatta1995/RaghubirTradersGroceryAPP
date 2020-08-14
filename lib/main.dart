import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raghuvir_traders/NavigationPages/AboutPage.dart';
import 'package:raghuvir_traders/NavigationPages/AdminForgotPassword.dart';
import 'package:raghuvir_traders/NavigationPages/AdminHomePage.dart';
import 'package:raghuvir_traders/NavigationPages/CartPage.dart';
import 'package:raghuvir_traders/NavigationPages/CustomerHomePage..dart';
import 'package:raghuvir_traders/NavigationPages/CustomerOrderHistory.dart';
import 'package:raghuvir_traders/NavigationPages/Login.dart';
import 'package:raghuvir_traders/NavigationPages/NewUser.dart';
import 'package:raghuvir_traders/NavigationPages/OrderPage.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.blueAccent,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAGHUVIR TRADERS GROCERY APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => Login(),
        CustomerHomePage.id: (context) => CustomerHomePage(),
        AdminHomePage.id: (context) => AdminHomePage(),
        NewUser.id: (context) => NewUser(),
        CartPage.id: (context) => CartPage(),
        OrderPage.id: (context) => OrderPage(),
        CustomerOrderHistory.id: (context) => CustomerOrderHistory(),
        AdminForgotPassword.id: (context) => AdminForgotPassword(),
        AboutPage.id: (context) => AboutPage(),
      },
    );
  }
}
