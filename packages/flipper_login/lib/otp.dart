import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/model/fuser.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_login/services/proxy_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
// ignore: implementation_imports
import 'package:redux/src/store.dart';
import 'package:stacked_services/stacked_services.dart';

import './loginResponse.dart';
import 'helpers/style.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({this.phone});
  final String phone;

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController number = TextEditingController();
  final NavigationService _navigationService = locator<NavigationService>();
  
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    proxyService.loading.listen((loading) {
      setState(() {
        _loading = loading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
        distinct: true,
        converter: CommonViewModel.fromStore,
        builder: (BuildContext context, CommonViewModel vm) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(text: 'Please enter'),
                        TextSpan(
                            text: ' Otp',
                            style: TextStyle(color: Colors.blue.shade900)),
                        const TextSpan(text: ' sent to your SMS'),
                      ],
                      style: const TextStyle(color: black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: Colors.blue, width: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: grey.withOpacity(0.3),
                              offset: const Offset(2, 1),
                              blurRadius: 2)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        controller: number,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.phone_android, color: grey),
                            border: InputBorder.none,
                            hintText: '123456',
                            hintStyle: TextStyle(
                                color: grey, fontFamily: 'Sen', fontSize: 18)),
                      ),
                    ),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    _loading
                        ? SizedBox(
                            width: 400,
                            height: 60,
                            child: RaisedButton(
                              color: Colors.blue,
                              onPressed: () {},
                              child: Loading(
                                indicator: BallPulseIndicator(),
                                size: 50.0,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 400,
                            height: 60,
                            child: RaisedButton(
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              padding: const EdgeInsets.all(0.0),
                              onPressed: () async {
                                if (number.text.isEmpty) {
                                  // TODO(richard): validation error message
                                  return;
                                }
                                if (vm.otpcode == null) {
                                  // TODO(richard): validation error message
                                  return;
                                }

                                try {
                                  proxyService.loading.add(true);
                                  final Auth.AuthCredential credential =
                                      Auth.PhoneAuthProvider.credential(
                                    verificationId: vm.otpcode,
                                    smsCode: number.text,
                                  );
                                  final Auth.FirebaseAuth auth =
                                      Auth.FirebaseAuth.instance;
                                  await auth.signInWithCredential(credential);
                                  final Auth.User currentUser =
                                      auth.currentUser;

                                  if (currentUser != null) {
                                    final http.Response response = await http
                                        .post('https://flipper.rw/open-login',
                                            body: {
                                          'phone_number': widget.phone
                                        },
                                            headers: {
                                          'Content-Type':
                                              'application/x-www-form-urlencoded',
                                          'Accept': 'application/json'
                                        });

                                    final LoginResponse loginResponse =
                                        loginResponseFromJson(response.body);
                                    final Store<AppState> store =
                                        StoreProvider.of<AppState>(context);

                                    final FUser user = FUser(
                                      (FUserBuilder user) => user
                                        ..email = loginResponse.email
                                        ..active = true
                                        ..createdAt =
                                            DateTime.now().toIso8601String()
                                        ..updatedAt =
                                            DateTime.now().toIso8601String()
                                        ..token = loginResponse.token
                                        ..name = loginResponse.name,
                                    );
                                    store.dispatch(WithUser(user: user));
                                    store.dispatch(
                                        UserID(userId: loginResponse.id));
                                    final UserTableData userExist = await store
                                        .state.database.userDao
                                        .getUser();
                                    if (userExist == null) {
                                      await store.state.database.userDao
                                          .insertUser(
                                        UserTableData(
                                          username: loginResponse.name,
                                          email: loginResponse.email,
                                          token: loginResponse.token,
                                          userId: loginResponse.id,
                                          id: null,
                                        ),
                                      );
                                    }

                                    proxyService.loading.add(false);
                                    // TODO: fix me so I won't have to go on signup page everytime.
                                    _navigationService.navigateTo(
                                      Routing.signUpScreen,
                                      arguments: SignUpScreenArguments(
                                        name: loginResponse.name,
                                        avatar: loginResponse.avatar,
                                        email: loginResponse.email,
                                        token: loginResponse.token,
                                      ),
                                    );
                                    store.dispatch(
                                        VerifyAuthenticationState()); //todo check subscription later refere to auth_webview.dart

                                  }
                                } catch (e) {
                                  proxyService.loading.add(false);
                                }
                              },
                              child: const Text(
                                'Proceed',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
