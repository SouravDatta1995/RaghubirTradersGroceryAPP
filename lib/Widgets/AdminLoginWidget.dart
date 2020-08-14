import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raghuvir_traders/NavigationPages/AdminForgotPassword.dart';
import 'package:raghuvir_traders/NavigationPages/AdminHomePage.dart';
import 'package:raghuvir_traders/Services/AdminLogin.dart';

class AdminLoginWidget extends StatefulWidget {
  @override
  _AdminLoginWidgetState createState() => _AdminLoginWidgetState();
}

class _AdminLoginWidgetState extends State<AdminLoginWidget> {
  String _uName, _pass;
  bool _incorrectPassword;
  @override
  void initState() {
    _incorrectPassword = false;
    _uName = "";
    _pass = "";
    super.initState();
  }

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
      titlePadding: EdgeInsets.zero,
      children: <Widget>[
        _incorrectPassword
            ? Container(
                height: 18.0,
                child: Center(
                  child: Text(
                    "Incorrect username/password",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            : Container(
                height: 18,
                width: 0,
              ),
        Container(
          height: 48.0,
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5.0),
              labelText: "Enter Username",
            ),
            onChanged: (value) {
              _uName = value;
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 48.0,
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5.0),
              labelText: "Enter Password",
            ),
            onChanged: (value) {
              _pass = value;
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          buttonPadding: EdgeInsets.symmetric(vertical: 8.0),
          children: <Widget>[
            GestureDetector(
              excludeFromSemantics: false,
              onTap: () {
                Navigator.pushNamed(context, AdminForgotPassword.id);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                AdminLogin.adminLogin(_uName, _pass).then((value) {
                  if (value == "Success") {
                    Navigator.pushNamedAndRemoveUntil(
                        context, AdminHomePage.id, (route) => false);
                  } else {
                    setState(() {
                      _incorrectPassword = true;
                    });
                  }
                });
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
