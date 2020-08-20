import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:raghuvir_traders/NavigationPages/AdminHomePage.dart';
import 'package:raghuvir_traders/Services/AdminLogin.dart';

class AdminForgotPassword extends StatefulWidget {
  static String id = "AdminForgotPassword";
  @override
  _AdminForgotPasswordState createState() => _AdminForgotPasswordState();
}

class _AdminForgotPasswordState extends State<AdminForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  String _uName, _newPass, _secretAnswer;
  bool _resetPass;
  @override
  void initState() {
    _resetPass = false;
    _uName = "";
    _newPass = "";
    _secretAnswer = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(MdiIcons.close),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (value) {
                    _uName = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter Username",

                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Secret Question : What is your Mother's pet name?",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  onChanged: (value) {
                    _secretAnswer = value;
                  },
                  decoration: InputDecoration(labelText: "Answer"),
                ),
              ),
              _resetPass
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        onChanged: (value) {
                          _newPass = value;
                        },
                        obscureText: true,
                        decoration: InputDecoration(labelText: "New Password"),
                      ),
                    )
                  : Container(
                      height: 0.0,
                      width: 0.0,
                    ),
              Builder(
                builder: (context) => FloatingActionButton.extended(
                  onPressed: _resetPass == false
                      ? () {
                          AdminLogin.validatePassword(_uName, _secretAnswer)
                              .then((value) {
                            if (value == "Success") {
                              setState(() {
                                _resetPass = true;
                              });
                            } else {
                              _formKey.currentState.reset();
                              _uName = "";
                              _newPass = "";
                              _secretAnswer = "";
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Some Error Occurred"),
                                ),
                              );
                            }
                          });
                        }
                      : () {
                          AdminLogin.resetPassword(
                                  _uName, _secretAnswer, _newPass)
                              .then((value) {
                            if (value == "Success") {
                              //print("Success");

                              Navigator.pushNamedAndRemoveUntil(
                                  context, AdminHomePage.id, (route) => false);
                            } else {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Incorrect Security Answer"),
                                ),
                              );
                            }
                          });
                        },
                  label: Text(_resetPass ? "Validate" : "Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
