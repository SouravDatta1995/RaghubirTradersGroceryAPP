import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raghubir_traders/NavigationPages/CustomerProductOverview..dart';

class OTPWidget extends StatefulWidget {
  @override
  _OTPWidgetState createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  List<String> otp = ['', '', '', ''];
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text('Please enter otp'),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _otpBox(0),
            _otpBox(1),
            _otpBox(2),
            _otpBox(3),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Resend'),
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, CustomerProductOverView.id);
                },
                child: Text("Submit"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 40,
      height: 40,
      child: TextField(
        onChanged: (value) {
          otp[index] = value;
        },
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          border: OutlineInputBorder(),
        ),
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
      ),
    );
  }
}
