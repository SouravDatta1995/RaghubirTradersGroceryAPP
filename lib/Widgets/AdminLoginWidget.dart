import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raghuvir_traders/NavigationPages/AdminHomePage.dart';

class AdminLoginWidget extends StatefulWidget {
  @override
  _AdminLoginWidgetState createState() => _AdminLoginWidgetState();
}

class _AdminLoginWidgetState extends State<AdminLoginWidget> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(16.0),
      title: Container(
        height: 48.0,
        color: Colors.blueAccent,
        child: Center(
          child: Text(
            "Login As Admin",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      titlePadding: EdgeInsets.only(bottom: 16.0),
      children: <Widget>[
        Container(
          height: 48.0,
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5.0),
              labelText: "Enter Username",
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 48.0,
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5.0),
              labelText: "Enter Password",
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          buttonPadding: EdgeInsets.symmetric(vertical: 8.0),
          children: <Widget>[
            Text("Forgot Password"),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, AdminHomePage.id);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text("Login"),
              ),
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            )
          ],
        ),
      ],
    );
  }
}
