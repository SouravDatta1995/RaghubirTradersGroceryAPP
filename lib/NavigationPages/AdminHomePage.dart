import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Widgets/AdminProductPage.dart';

class AdminHomePage extends StatefulWidget {
  static String id = "AdminHomePage";
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<Widget> _bodyWidgets = [
    AdminProductPage(),
  ];
  List<BottomNavigationBarItem> _navBarItems = [
    BottomNavigationBarItem(
      icon: Icon(
        MdiIcons.formatListText,
      ),
      title: Text("PRODUCTS"),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        MdiIcons.notificationClearAll,
      ),
      title: Text("ORDERS"),
    ),
  ];
  int index;
  @override
  void initState() {
    index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome <Admin>"),
      ),
      body: _bodyWidgets[0],
      bottomNavigationBar: BottomNavigationBar(items: _navBarItems),
    );
  }
}
