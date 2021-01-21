import 'package:firebase_auth/firebase_auth.dart' as Auth;

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flipper/routes/router.gr.dart';

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
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
                                  final _analytics =
                                      locator<AnalyticsService>();

                                  if (currentUser != null) {
                                    final http.Response response =
                                        await loginToFlipper();

                                    final LoginResponse loginResponse =
                                        loginResponseFromJson(response.body);
                                    final Store<AppState> store =
                                        StoreProvider.of<AppState>(context);
                                    //the user does not exist into the couch adding him will trigger the listner and proceed
                                    // if he is synced i.e exist in couch then the sync which was started will add the user to local
                                    // database then trigger a change and continue as expected
                                    await userExistInCouchbase(loginResponse);
                                    await buildUser(loginResponse, store);
                                    _analytics.setUserProperties(
                                        userId: loginResponse.id.toString(),
                                        userRole: 'Admin');
                                    _analytics.logLogin();
                                    ProxyService.database.login(channels: [
                                      loginResponse.id.toString()
                                    ]);
                                    // final log = Logging.getLogger('OTP:');
                                    final loggedInUserId = await ProxyService
                                        .sharedPref
                                        .getUserId();
                                    if (loggedInUserId == null) {
                                      final q = Query(ProxyService.database.db,
                                          'SELECT * WHERE table=\$VALUE AND name=\$NAME');

                                      q.parameters = {
                                        'VALUE': AppTables.user,
                                        'NAME': widget.phone.replaceAll(
                                            RegExp(r'\s+\b|\b\s'), '')
                                      };
                                      q.addChangeListener((results) {
                                        for (Map map in results) {
                                          map.forEach((key, value) {
                                            final FUser user =
                                                FUser.fromMap(value);
                                            //  a user exist in couchbase then go to auth verification this,
                                            if (user != null) {
                                              ProxyService.sharedPref
                                                  .setUserLoggedIn(
                                                      userId: loginResponse.id
                                                          .toString());
                                              StoreProvider.of<AppState>(
                                                      context)
                                                  .dispatch(
                                                      VerifyAuthenticationState());

                                              proxyService.loading.add(false);
                                            }
                                          });
                                        }
                                      });
                                    }
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

  Future<http.Response> loginToFlipper() async {
    print(widget.phone.replaceAll(RegExp(r'\s+\b|\b\s'), ''));
    final http.Response response =
        await http.post('https://flipper.rw/open-login', body: {
      'phone': widget.phone.replaceAll(RegExp(r'\s+\b|\b\s'), '')
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json'
    });
    // save a device token for this client
    final String token = await ProxyService.sharedPref.getToken();
    final String phone = widget.phone.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    await http.post('https://flipper.rw/save-token', body: {
      'phone': phone,
      'token': token
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json'
    });
    //end saving the token
    return response;
  }

  Future<void> userExistInCouchbase(LoginResponse loginResponse) async {
    if (loginResponse.synced == 0) {
      ProxyService.database.insert(data: {
        'name': loginResponse.name,
        'email': loginResponse.email,
        'token': loginResponse.token,
        'table': AppTables.user,
        'channels': [loginResponse.id.toString()],
        'userId': loginResponse.id.toString(),
        'expiresAt': loginResponse.expiresAt,
        'id': loginResponse.id.toString(),
      });
      // call the API to update the user synced status

      final String phone = widget.phone.replaceAll(RegExp(r'\s+\b|\b\s'), '');
      await http.post('https://flipper.rw/synced', body: {
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
    store.dispatch(WithUser(user: user));
  }
}
