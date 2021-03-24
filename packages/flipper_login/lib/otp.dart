import 'package:firebase_auth/firebase_auth.dart';

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flipper/routes/router.gr.dart';

import 'package:flipper_services/analytics_service.dart';
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper_login/services/proxy_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:redux/redux.dart';
import 'package:get/get.dart' as gete;
import 'package:flipper_models/fuser.dart';
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
  final FlipperNavigationService _navigationService = ProxyService.nav;

  bool _loading = false;
  @override
  void initState() {
    super.initState();
    // ignore: always_specify_types
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
                            text: ' OTP',
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
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.black),
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
                                  snackBarMessage(
                                      message: 'Try again',
                                      title: 'Invalid Number');
                                  return;
                                }
                                if (vm.otpcode == null) {
                                  snackBarMessage(
                                      message: 'Try again',
                                      title: 'Invalid OTP');
                                  return;
                                }
                                try {
                                  proxyService.loading.add(true);
                                  final AuthCredential credential =
                                      PhoneAuthProvider.credential(
                                    verificationId: vm.otpcode,
                                    smsCode: number.text,
                                  );
                                  final FirebaseAuth auth =
                                      FirebaseAuth.instance;
                                  await auth.signInWithCredential(credential);

                                  final _analytics =
                                      locator<AnalyticsService>();

                                  FirebaseAuth.instance
                                      .authStateChanges()
                                      .listen((User user) async {
                                    if (user == null) {
                                      snackBarMessage(
                                          message: 'Try again',
                                          title: 'User Sign out');
                                    } else {
                                      final http.Response response =
                                          await loginToFlipper();
                                      final LoginResponse loginResponse =
                                          loginResponseFromJson(response.body);
                                      final Store<AppState> store =
                                          StoreProvider.of<AppState>(context);

                                      await ProxyService.database.login(
                                          channels: [
                                            loginResponse.id.toString()
                                          ]);

                                      await userExistInCouchbase(loginResponse);
                                      await buildUser(loginResponse, store);
                                      _analytics.setUserProperties(
                                          userId: loginResponse.id.toString(),
                                          userRole: 'Admin');
                                      _analytics.logLogin();
                                      StoreProvider.of<AppState>(context)
                                          .dispatch(
                                              VerifyAuthenticationState());
                                    }
                                  });
                                } catch (e) {
                                  snackBarMessage(
                                      message: 'Try again',
                                      title: 'Server error');
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

  void snackBarMessage({String message, String title}) {
    return gete.Get.snackbar(
      'Internal server',
      'Try again',
      backgroundColor: Colors.grey,
      snackPosition: gete.SnackPosition.BOTTOM,
      borderColor: Colors.indigo,
      borderRadius: 0,
      borderWidth: 2,
      barBlur: 0,
    );
  }

  Future<http.Response> loginToFlipper() async {
    final String phoneNumber =
        widget.phone.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    final http.Response response =
        await http.post('https://flipper.yegobox.com/open-login', body: {
      'phone': phoneNumber
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json'
    });
    return response;
  }

  /// the user does not exist into the couch adding him will trigger the listner and proceed
  /// if he is synced i.e exist in couch then the sync which was started will add the user to local
  /// database then trigger a change and continue as expected
  Future<void> userExistInCouchbase(LoginResponse loginResponse) async {
    if (loginResponse.synced == 0) {
      ProxyService.database.insert(id: loginResponse.id.toString(), data: {
        'name': loginResponse.name,
        'email': loginResponse.email,
        'token': loginResponse.token,
        'table': AppTables.user,
        'channels': [loginResponse.id.toString()],
        'userId': loginResponse.id.toString(),
        'expiresAt': 'null',
        'id': 'null',
      });

      // call the API to update the user synced status

      final String phone = widget.phone.replaceAll(RegExp(r'\s+\b|\b\s'), '');
      await http.post('https://flipper.yegobox.com/synced', body: {
        'synced': 'true',
        'phone': phone,
      }, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
      });

      // end of updating the status
      ProxyService.sharedPref
          .setUserLoggedIn(userId: loginResponse.id.toString());

      _navigationService.navigateTo(
        Routing.signUpView,
        arguments: SignUpViewArguments(
          name: loginResponse.name,
          avatar: loginResponse.avatar,
          email: loginResponse.email,
          token: loginResponse.token,
          userId: loginResponse.id.toString(),
        ),
      );
    } else {
      ProxyService.sharedPref
          .setUserLoggedIn(userId: loginResponse.id.toString());
      // always insert to avoid when a user has uninstalled the app and it need some time to sync up again atleast we need user
      ProxyService.database.insert(id: loginResponse.id.toString(), data: {
        'name': loginResponse.name,
        'token': loginResponse.token,
        'table': AppTables.user,
        'channels': [loginResponse.id.toString()],
        'userId': loginResponse.id.toString(),
        'expiresAt': loginResponse.expiresAt,
        'id': loginResponse.id.toString(),
      });
    }
  }

  Future<void> buildUser(
      LoginResponse loginResponse, Store<AppState> store) async {
    final FUser user = FUser(
      (user) async => user
        ..email = loginResponse.email
        ..active = true
        ..id = loginResponse.id.toString()
        ..userId = loginResponse.id.toString()
        ..createdAt = DateTime.now().toIso8601String()
        ..updatedAt = DateTime.now().toIso8601String()
        ..token = loginResponse.token
        ..name = loginResponse.name,
    );
    ProxyService.sharedState.setUser(
        user: FUser.fromMap({
      'email': loginResponse.email,
      'active': true,
      'id': loginResponse.id.toString(),
      'userId': loginResponse.id.toString(),
      'createdAt': 'null',
      'updatedAt': 'null',
      'token': loginResponse.token,
      'name': loginResponse.name
    }));
    store.dispatch(WithUser(user: user));
  }
}
