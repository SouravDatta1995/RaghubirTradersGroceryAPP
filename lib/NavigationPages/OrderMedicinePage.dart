import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Services/ApplicationUrlService.dart';

class OrderMedicinePage extends StatefulWidget {
  static String id = "OrderMedicinePage";
  @override
  _OrderMedicinePageState createState() => _OrderMedicinePageState();
}

class _OrderMedicinePageState extends State<OrderMedicinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppDataBLoC.primaryColor,
        title: Text(
          "Order Medicine",
          style: TextStyle(color: AppDataBLoC.secondaryColor),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actionsIconTheme: IconThemeData(color: AppDataBLoC.secondaryColor),
        actions: [
          GestureDetector(
            excludeFromSemantics: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(MdiIcons.close),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "To order Medicine kindly contact via Phone/Whatsapp",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppDataBLoC.primaryColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: null,
                  child: Icon(MdiIcons.phone),
                  onPressed: () => ApplicationUrlService.launchPhone(),
                ),
                FloatingActionButton(
                  heroTag: null,
                  child: Icon(MdiIcons.whatsapp),
                  onPressed: () => ApplicationUrlService.launchWhatsApp(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
