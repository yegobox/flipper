import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as Auth;
import './loginResponse.dart';
import 'package:flipper_login/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

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
            TextFormField(
              onChanged: (code) async {
                //
                setState(() {
                  _code = code;
                });
              },
              //now notify other about the user
            ),
            RaisedButton(
                onPressed: () async {
                  if (_verificationId.isEmpty) {
                    return;
                  }
                  if(_code.isEmpty){
                    return;
                  }
                  final Auth.AuthCredential credential =
                      Auth.PhoneAuthProvider.credential(
                    verificationId: _verificationId,
                    smsCode: _code,
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
                child: Text('continue'))
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
