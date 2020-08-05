import 'package:flutter/material.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/UserData.dart';
import 'package:raghuvir_traders/NavigationPages/CustomerHomePage..dart';
import 'package:raghuvir_traders/NavigationPages/NewUser.dart';
import 'package:raghuvir_traders/Services/UserLoginService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogin {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<void> setCachePhoneNumber(int phoneNo) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('UserPhoneNumber', phoneNo);
  }

  static Future<Map<String, dynamic>> getUserLogin(
      BuildContext context, String phoneNumber) {
    return UserLoginService.loginUser(phoneNumber).then((value) {
      String _userType = value.keys.toList()[0];
      UserData _userData = value.values.toList()[0];
      print("UserType:" + _userType);
      if (_userType == "Existing User") {
        setCachePhoneNumber(int.parse(phoneNumber));
        AppDataBLoC.data = _userData;
        Navigator.pushNamedAndRemoveUntil(
          context,
          CustomerHomePage.id,
          ModalRoute.withName(CustomerHomePage.id),
        );
      } else if (_userType == "New User") {
        Navigator.pushNamedAndRemoveUntil(
          context,
          NewUser.id,
          ModalRoute.withName(NewUser.id),
          arguments: phoneNumber,
        );
      } else {
        return {"Error:": "Some Error Occurred"};
      }

      return value;
    });
  }
}
