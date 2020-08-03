import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:raghuvir_traders/Elements/UserLogin.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class OTPWidget extends StatefulWidget {
  final String phoneNumber;
  OTPWidget({this.phoneNumber});
  @override
  _OTPWidgetState createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  String _otpCode;
  bool _isAutoFill, _resendStatus;
  _getSignature() async {
    String signature = await SmsRetrieved.getAppSignature();
    print("Signature : " + signature);
  }

  _onOtpCallback(String otpCode, bool isAutoFill) {
    setState(() {
      this._otpCode = otpCode;
      this._isAutoFill = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _otpCode = "";
    _isAutoFill = false;
    _resendStatus = false;
    _loginLoad = true;
    _getSignature();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Please enter otp'),
              Expanded(
                child: SizedBox(),
              ),
              _isAutoFill == false
                  ? Container(
                      height: 12.0,
                      width: 12.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    )
                  : Container(
                      height: 0.0,
                      width: 0.0,
                    ),
            ],
          ),
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
          onOtpCallback: (code, isAutoFill) => _onOtpCallback(code, isAutoFill),
        ),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _resendStatus
                  ? GestureDetector(
                      child: Text(
                        'Resend',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        setState(() {
                          _resendStatus = false;
                        });
                      },
                    )
                  : TweenAnimationBuilder(
                      tween: Tween(
                        begin: 60.0,
                        end: 0.0,
                      ),
                      duration: Duration(seconds: 60),
                      onEnd: () {
                        setState(() {
                          _resendStatus = true;
                        });
                      },
                      builder:
                          (BuildContext context, double value, Widget child) {
                        String val = "(" + value.ceil().toString() + ")";
                        return Text('Resend' + val);
                      },
                    ),
              _loginButton(),
            ],
          ),
        ),
      ],
    );
  }

  bool _loginLoad;
  Widget _loginButton() {
    return _otpCode.length != 4
        ? RaisedButton(
            child: Text("Submit"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            onPressed: null,
          )
        : RaisedButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              setState(() {
                _loginLoad = true;
              });
            },
            color: Colors.blueAccent,
            child: _loginLoad
                ? FutureBuilder<Map<String, dynamic>>(
                    future: UserLogin.getUserLogin(context, widget.phoneNumber),
                    builder: (context, snapshot) {
                      return Container(
                        height: 15.0,
                        width: 15.0,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      );
                    },
                  )
                : Text("Submit"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          );
  }
}
