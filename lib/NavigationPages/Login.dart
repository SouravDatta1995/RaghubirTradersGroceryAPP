import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:raghuvir_traders/Widgets/AdminLoginWidget.dart';
import 'package:raghuvir_traders/Widgets/OTPWidget.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.blueAccent,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Center(child: Text("RAGHUVIR TRADERS")),
                ),
                _customerLogin(),
                Expanded(
                  child: _adminLogin(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customerLogin() {
    return Container(
      height: 170,
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextField(
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  labelText: 'Enter phone number',
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                  prefix: Text('+91  '),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
              ),
              SizedBox(
                height: 16.0,
              ),
              RaisedButton(
                onPressed: () {
                  _showOTPDialog();
                },
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                    child: Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _adminLogin() {
    return GestureDetector(
      excludeFromSemantics: false,
      child: Center(
        child: FlatButton(
          onPressed: () {
            _showAdminLoginDialog();
          },
          child: Text(
            "Login as Admin",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Future<void> _showOTPDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return OTPWidget();
      },
    );
  }

  Future<void> _showAdminLoginDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AdminLoginWidget();
      },
    );
  }
}
