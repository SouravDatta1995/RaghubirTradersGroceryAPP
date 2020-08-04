import 'package:flutter/material.dart';
import 'package:raghuvir_traders/NavigationPages/CustomerHomePage..dart';
import 'package:raghuvir_traders/Services/UserLoginService.dart';

class NewUser extends StatefulWidget {
  static String id = "NewUser";
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  String _fName, _lName;
  bool _newUserLoad = false;
  @override
  Widget build(BuildContext context) {
    final String phoneNumber = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Welcome",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Please Enter your Name to continue"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        _fName = value;
                      },
                      decoration: InputDecoration(
                        labelText: "First Name",
                      ),
                    ),
                  ),
                  Container(
                    width: 16.0,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        _lName = value;
                      },
                      decoration: InputDecoration(
                        labelText: "Last Name",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: newUserBtn(phoneNumber),
            ),
          ],
        ),
      ),
    );
  }

  Widget newUserBtn(String phoneNumber) {
    return _fName == "" || _lName == ""
        ? RaisedButton(
            onPressed: null,
            child: Text("Continue"),
          )
        : RaisedButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              setState(() {
                _newUserLoad = true;
              });
            },
            color: Colors.blueAccent,
            child: _newUserLoad == false
                ? Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  )
                : FutureBuilder(
                    future: UserLoginService.addUser(
                            phoneNumber, _fName.trim() + " " + _lName.trim())
                        .then((value) {
                      if (value.keys.toList()[0] == "User")
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            CustomerHomePage.id,
                            ModalRoute.withName(CustomerHomePage.id),
                            arguments: value.values.toList()[0]);
                      return value;
                    }),
                    builder: (context, snapshot) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
          );
  }
}
