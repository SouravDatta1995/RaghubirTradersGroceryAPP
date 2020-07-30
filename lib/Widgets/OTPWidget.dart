import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raghuvir_traders/NavigationPages/CustomerHomePage..dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class OTPWidget extends StatefulWidget {
  @override
  _OTPWidgetState createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  List<String> otp = ['', '', '', ''];
  String _otpCode;
  _getSignature() async {
    String signature = await SmsRetrieved.getAppSignature();
    print("Signature : " + signature);
  }

  _onOtpCallback(String otpCode, bool isAutofill) {
    setState(() {
      this._otpCode = otpCode;
    });
  }

  @override
  void initState() {
    super.initState();
    _getSignature();
  }

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
        TextFieldPin(
          codeLength: 4,
          boxSize: 46,
          filledAfterTextChange: false,
          textStyle: TextStyle(fontSize: 16),
          borderStyle:
              OutlineInputBorder(borderRadius: BorderRadius.circular(34)),
          onOtpCallback: (code, isAutofill) => _onOtpCallback(code, isAutofill),
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
                  Navigator.pushNamed(context, CustomerHomePage.id);
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
}
