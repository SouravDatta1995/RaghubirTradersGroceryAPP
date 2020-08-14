import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAGHUVIR TRADERS GROCERY APP',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
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
      },
    );
  }
}
