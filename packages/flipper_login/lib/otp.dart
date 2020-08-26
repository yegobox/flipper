import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as Auth;
import './loginResponse.dart';
import 'package:flipper_login/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

import 'helpers/style.dart';
import 'providers/auth.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text.dart';

StreamController<String> otp = StreamController<String>();
Stream optstream = otp.stream;

class OtpPage extends StatefulWidget {
  OtpPage({Key key, this.phone, this.verificationId}) : super(key: key);

  final String phone;
  final String verificationId;
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with CodeAutoFill {
  String _code;
  String _verificationId;
  TextEditingController number = TextEditingController();

  String phoneNumber;
  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  @override
  void initState() {
    super.initState();

    listenForCode();

    loginStream.listen((verificationId) {
      setState(() {
        _verificationId = verificationId;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RichText(
                text: TextSpan(children: [
                  TextSpan(text: "Please enter"),
                  TextSpan(text: " Otp", style: TextStyle(color: Colors.blue.shade900)),
                  TextSpan(text: " set to your SMS"),
                ], style: TextStyle(color: black))),
            SizedBox(height: 10),
//            CustomText( "Error here", color: red,),
            Padding(
              padding: const EdgeInsets.only(left:12, right: 12, bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: Colors.blue, width: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: grey.withOpacity(0.3),
                          offset: Offset(2, 1),
                          blurRadius: 2
                      )
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: number,
                    decoration: InputDecoration(
                        icon: Icon(Icons.phone_android, color: grey),
                        border: InputBorder.none,
                        hintText: "123456",
                        hintStyle: TextStyle(
                            color: grey,
                            fontFamily: "Sen",
                            fontSize: 18
                        )
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: SizedBox(
                width: 380,
                height: 60,
                child: RaisedButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.blue,)),
                  padding: const EdgeInsets.all(0.0),
                  onPressed: () async{
                    if (_verificationId.isEmpty) {
                      return;
                    }
                    if(number.value.isEmpty){
                      return;
                    }
                    final Auth.AuthCredential credential =
                    Auth.PhoneAuthProvider.credential(
                      verificationId: _verificationId,
                      smsCode: number.value,
                    );
                    Auth.FirebaseAuth auth = Auth.FirebaseAuth.instance;
                    await auth.signInWithCredential(credential);
                    final Auth.User currentUser = auth.currentUser;
                    print(currentUser);
                    if(currentUser !=null){
                      final response =   await http.post('https://flipper.rw/open-login', body: {
                        'code': code,
                        'phone_number': widget.phone
                      }, headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'Accept': 'application/json'
                      });

                      final loginResponse = loginResponseFromJson(response.body);
                      print(loginResponse);
                    }
                  },
                  child: Text(
                    'Proceed',
                    style: const TextStyle(color: Colors.white,fontSize: 20),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  @override
  void codeUpdated() {
    setState(() {
      _code = code;
    });
  }
}
