import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Widgets/AdminOrdersPage.dart';
import 'package:raghuvir_traders/Widgets/AdminProductPage.dart';

class AdminHomePage extends StatefulWidget {
  static String id = "AdminHomePage";
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<Widget> _bodyWidgets = [
    AdminProductPage(),
    AdminOrdersPage(),
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
  int _selectedIndex;
  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pushNamedAndRemoveUntil(
              context, "/", ModalRoute.withName("/")),
          child: Icon(
            MdiIcons.arrowLeft,
            color: Colors.white,
          ),
        ),
        title: Text("Welcome <Admin>"),
      ),
      body: _bodyWidgets[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navBarItems,
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
