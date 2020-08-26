import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as Auth;
import './loginResponse.dart';
import 'package:flipper_login/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;
import 'package:flipper/domain/redux/app_state.dart';
import 'helpers/style.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flipper/model/user.dart';
import 'providers/auth.dart';
import 'widgets/custom_button.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/data/main_database.dart';
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
                    if(number.text.isEmpty){
                      return;
                    }
                    final Auth.AuthCredential credential =
                    Auth.PhoneAuthProvider.credential(
                      verificationId: _verificationId,
                      smsCode: number.text,
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
                      final store = StoreProvider.of<AppState>(context);
                      print(loginResponse);
                      FUser user = FUser(
                            (user) => user
                          ..email = loginResponse.email
                          ..active = true
                          ..createdAt = DateTime.now().toIso8601String()
                          ..updatedAt = DateTime.now().toIso8601String()
                          ..token = loginResponse.token
                          ..name = loginResponse.name,
                      );
                      store.dispatch(WithUser(user: user));
                      store.dispatch(UserID(userId: loginResponse.id));
                      UserTableData userExist =
                      await store.state.database.userDao.getUser();
                      if (userExist == null) {
                               await store.state.database.userDao.insertUser(UserTableData(
                                   username: loginResponse.name,
                                   email: loginResponse.email,
                                   token: loginResponse.token,
                                   userId: loginResponse.id,),);
                             }
                      if(loginResponse.newUser){
                        Routing.navigator.pushNamed(
                          Routing.signUpScreen,
                          arguments: SignUpScreenArguments(
                            name: loginResponse.name,
                            avatar: loginResponse.avatar,
                            email: loginResponse.email,
                            token: loginResponse.token,
                          ),
                        );
                      }else{
                        store.dispatch(VerifyAuthenticationState()); //todo check subscription later refere to auth_webview.dart
                      }
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
