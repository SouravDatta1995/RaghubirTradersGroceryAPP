import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/UserLogin.dart';
import 'package:raghuvir_traders/Widgets/AdminLoginWidget.dart';
import 'package:raghuvir_traders/Widgets/OTPWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _phoneNumber = "";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _cachedPhoneNumber;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _prefs.then((value) => value.getInt('UserPhoneNumber') ?? 0).then((value) {
      setCachePhoneNum(value);
      if (value != 0) {
        Future(() {
          UserLogin.getUserLogin(context, value.toString());
        });
      }
    });

    super.initState();
  }

  setCachePhoneNum(int value) {
    setState(() {
      _cachedPhoneNumber = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  color: AppDataBLoC.primaryColor,
                ),
              ),
              Expanded(
                child: Container(
                  color: AppDataBLoC.secondaryColor,
                ),
              ),
            ],
          ),
          _cachedPhoneNumber == 0
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "R",
                                    style: TextStyle(
                                        fontSize: 72,
                                        color: AppDataBLoC.secondaryColor),
                                  ),
                                  Text(
                                    "\nT",
                                    style: TextStyle(
                                        fontSize: 72,
                                        color: AppDataBLoC.secondaryColor),
                                  ),
                                ],
                              ),
                              Center(
                                child: Text(
                                  "Raghuvir Traders",
                                  style: TextStyle(
                                      color: AppDataBLoC.secondaryColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      _customerLogin(),
                      Expanded(
                        child: _adminLogin(),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Container(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppDataBLoC.secondaryColor),
                    ),
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
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _phoneNumber = value;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              RaisedButton(
                onPressed: () {
//                  TODO : Uncomment for otp
//                  UserLoginService.sendOtp(_phoneNumber);
                  _showOTPDialog();
                },
                color: AppDataBLoC.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                    child: Text(
                  "LOGIN",
                  style: TextStyle(color: AppDataBLoC.secondaryColor),
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
            style: TextStyle(color: AppDataBLoC.primaryColor),
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
        return OTPWidget(
          phoneNumber: _phoneNumber,
        );
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
