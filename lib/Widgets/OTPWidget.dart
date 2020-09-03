import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:raghuvir_traders/Elements/AppDataBLoC.dart';
import 'package:raghuvir_traders/Elements/UserLogin.dart';
import 'package:raghuvir_traders/Services/UserLoginService.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPWidget extends StatefulWidget {
  final String phoneNumber;
  OTPWidget({this.phoneNumber});
  @override
  _OTPWidgetState createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  String _otpCode;
  bool _isAutoFill, _resendStatus, _validOtp;
  _getSignature() async {
    await SmsAutoFill().getAppSignature;
  }

  _onOtpCallback(String otpCode) {
    setState(() {
      this._otpCode = otpCode;
    });
  }

  @override
  void initState() {
    super.initState();
    _otpCode = "";
    _isAutoFill = false;
    _resendStatus = false;
    _loginLoad = true;
    _validOtp = true;
    _getSignature();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: AppDataBLoC.secondaryColor,
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
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppDataBLoC.primaryColor),
                      ),
                    )
                  : Container(
                      height: 0.0,
                      width: 0.0,
                    ),
            ],
          ),
        ),
        _validOtp
            ? Container(
                height: 16.0,
                width: 0.0,
              )
            : Container(
                height: 16.0,
                child: Center(
                  child: Text(
                    "Invalid Otp",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: PinFieldAutoFill(
            codeLength: 4,
            decoration: CirclePinDecoration(
              strokeColor: AppDataBLoC.primaryColor,
              textStyle: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            autofocus: true,
            keyboardType: TextInputType.number,
            currentCode: _otpCode,
            onCodeSubmitted: (code) {
              _isAutoFill = true;
            },
            onCodeChanged: (code) {
              _onOtpCallback(code);
              if (code.length == 4) {
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
          ),
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
                        style: TextStyle(color: AppDataBLoC.primaryColor),
                      ),
                      onTap: () {
                        setState(() {
                          UserLoginService.sendOtp(widget.phoneNumber);
                          _resendStatus = false;
                        });
                      },
                      excludeFromSemantics: false,
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
            color: AppDataBLoC.secondaryColor,
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
                _validOtp = true;
              });
            },
            color: AppDataBLoC.primaryColor,
            child: _loginLoad
                ? OtpButton(
                    phoneNumber: widget.phoneNumber,
                    loginLoad: _callbackLoginLoad,
                    validateOtp: _callbackValidateOtp,
                    otpCode: _otpCode,
                  )
                : Text("Submit"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          );
  }

  _callbackValidateOtp(bool val) {
    setState(() {
      _validOtp = val;
    });
  }

  _callbackLoginLoad(bool val) {
    setState(() {
      _loginLoad = val;
    });
  }
}

class OtpButton extends StatefulWidget {
  final String phoneNumber, otpCode;
  final Function(bool) validateOtp, loginLoad;
  const OtpButton(
      {Key key,
      this.phoneNumber,
      this.validateOtp,
      this.loginLoad,
      this.otpCode})
      : super(key: key);

  @override
  _OtpButtonState createState() => _OtpButtonState();
}

class _OtpButtonState extends State<OtpButton> {
  @override
  void initState() {
    //TODO
    UserLogin.getUserLoginViaOtp(context, widget.phoneNumber, widget.otpCode)
        .then((value) {
      if (value.keys.toList()[0] == "Error") {
        widget.validateOtp(false);
      }
      widget.loginLoad(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,
      width: 20.0,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(AppDataBLoC.secondaryColor),
      ),
    );
  }
}
