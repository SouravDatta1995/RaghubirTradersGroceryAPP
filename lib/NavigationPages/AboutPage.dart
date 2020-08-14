import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  static String id = "AboutPage";
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Page"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 16.0,
          ),
          ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text("Raghuvir Traders App")),
                Center(child: Text("Developed using Flutter")),
                Center(child: Text("by Mukherjee Solutions")),
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          ListTile(
            dense: true,
            title: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Used Plugins",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Center(
                      child: Text("material_design_icons_flutter: ^4.0.5345")),
                  Center(child: Text("cached_network_image: ^2.2.0+1")),
                  Center(child: Text("sms_autofill: ^1.2.3")),
                  Center(child: Text("image_picker: ^0.6.7+4")),
                  Center(child: Text("image_cropper: ^1.2.3")),
                  Center(child: Text("http: ^0.12.2")),
                  Center(child: Text("shared_preferences: ^0.5.8")),
                  Center(child: Text("rxdart: ^0.24.1")),
                  Center(child: Text("dio: ^3.0.9")),
                  Center(child: Text("geolocator: ^5.3.2+2")),
                  Center(child: Text("razorpay_flutter: ^1.2.2")),
                  Center(child: Text("url_launcher: ^5.5.0")),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          ListTile(
            title: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Version 1.0.0"),
            )),
          ),
        ],
      ),
    );
  }
}
