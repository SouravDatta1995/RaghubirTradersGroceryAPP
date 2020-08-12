import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/NavigationPages/CustomerHomePage..dart';
import 'package:raghuvir_traders/Services/UserLoginService.dart';

class NewUser extends StatefulWidget {
  static String id = "NewUser";
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  String _fName, _lName;
  bool _newUserLoad;
  String _address, _additionalAddress;
  @override
  void initState() {
    _address = "";
    _additionalAddress = "";
    _fName = "";
    _lName = "";
    _newUserLoad = false;
    super.initState();
  }

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
              child: addressField(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  _additionalAddress = value;
                },
                decoration: InputDecoration(
                    labelText: "Flat No/House No/Additional details"),
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
    return Builder(
      builder: (context) => RaisedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          setState(() {
            if (_fName == "" || _lName == "" || _address == "")
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Please fill all the fields"),
              ));
            else
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
                        phoneNumber,
                        _fName.trim() + " " + _lName.trim(),
                        _address + _additionalAddress)
                    .then((value) {
                  if (value.keys.toList()[0] == "User")
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        CustomerHomePage.id,
                        ModalRoute.withName(CustomerHomePage.id),
                        arguments: value.values.toList()[0]);
                  AppDataBLoC.data = value.values.toList()[0];
                  return value;
                }),
                builder: (context, snapshot) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }

  Widget addressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<Position>(
                future: Geolocator()
                    .getCurrentPosition(desiredAccuracy: LocationAccuracy.best),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return FutureBuilder<List<Placemark>>(
                      future: Geolocator().placemarkFromPosition(snapshot.data),
                      builder: (context, snapshot1) {
                        if (snapshot1.hasData) {
                          Placemark placeMark = snapshot1.data[0];
                          String name = placeMark.name + ", ";
                          String subLocality = placeMark.subLocality != ""
                              ? placeMark.subLocality + ", "
                              : "";
                          String locality = placeMark.locality != ""
                              ? placeMark.locality + ", "
                              : "";
                          String administrativeArea =
                              placeMark.administrativeArea != ""
                                  ? placeMark.administrativeArea + ", "
                                  : "";
                          String postalCode = placeMark.postalCode + ", ";
                          String country = placeMark.country;
                          _address = name +
                              subLocality +
                              locality +
                              administrativeArea +
                              postalCode +
                              country;
                          //print(_position);

                          return Text(
                            _address,
                          );
                        } else {
                          return Text("Detecting...");
                        }
                      },
                    );
                  } else {
                    return Text("Detecting...");
                  }
                },
              ),
            ),
            Icon(
              Icons.my_location,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }
}
