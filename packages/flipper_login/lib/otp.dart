import 'package:firebase_auth/firebase_auth.dart' as Auth;

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/routes/router.gr.dart';

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/services/analytics_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/fuser.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper_login/services/proxy_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:redux/redux.dart';

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
                                    final http.Response response = await http
                                        .post('https://flipper.rw/open-login',
                                            body: {
                                          'phone': widget.phone
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
                                      // ignore: always_specify_types
                                      (user) async => user
                                        ..email = loginResponse.email
                                        ..active = true
                                        ..id = loginResponse.id.toString()
                                        ..userId = loginResponse.id.toString()
                                        ..createdAt =
                                            DateTime.now().toIso8601String()
                                        ..updatedAt =
                                            DateTime.now().toIso8601String()
                                        ..token = loginResponse.token
                                        ..name = loginResponse.name,
                                    );
                                    store.dispatch(WithUser(user: user));
                                    _analytics.setUserProperties(
                                        userId: loginResponse.id.toString(),
                                        userRole: 'Adamin');
                                    _analytics.logLogin();

                                    final loggedInUserId = await ProxyService
                                        .sharedPref
                                        .getUserId();
                                    if (loggedInUserId == null) {
                                      final q = Query(ProxyService.database.db,
                                          'SELECT * WHERE table=\$VALUE AND id=\$ID');

                                      q.parameters = {
                                        'VALUE': AppTables.user,
                                        'ID': loginResponse.id.toString()
                                      };
                                      final log = Logging.getLogger('OTP:');
                                      final user = q.execute();
                                      if (user.isNotEmpty) {
                                        log.d(user);

                                        bool userInCouch = false;
                                        for (Map map in user) {
                                          map.forEach((key, value) {
                                            if (value.containsKey('userId') &&
                                                FUser.fromMap(value).userId ==
                                                    loginResponse.id
                                                        .toString()) {
                                              userInCouch = true;
                                              ProxyService.sharedPref
                                                  .setUserLoggedIn(
                                                      userId: loginResponse.id
                                                          .toString());
                                            } else {
                                              userInCouch = false;
                                            }
                                          });
                                        }
                                        if (userInCouch) {
                                          StoreProvider.of<AppState>(context)
                                              .dispatch(
                                                  VerifyAuthenticationState());
                                          proxyService.loading.add(false);
                                          return;
                                        } else {
                                          ProxyService.database.insert(
                                              id: loginResponse.id.toString(),
                                              data: {
                                                'name': loginResponse.name,
                                                'email': loginResponse.email,
                                                'token': loginResponse.token,
                                                'table': AppTables.user,
                                                'userId':
                                                    loginResponse.id.toString(),
                                                'expiresAt':
                                                    loginResponse.expiresAt,
                                                'id':
                                                    loginResponse.id.toString(),
                                              });
                                          ProxyService.sharedPref
                                              .setUserLoggedIn(
                                                  userId: loginResponse.id
                                                      .toString());
                                          proxyService.loading.add(false);

                                          _navigationService.navigateTo(
                                            Routing.signUpView,
                                            arguments: SignUpViewArguments(
                                                name: loginResponse.name,
                                                avatar: loginResponse.avatar,
                                                email: loginResponse.email,
                                                token: loginResponse.token,
                                                userId: loginResponse.id
                                                    .toString()),
                                          );
                                        }
                                      } else {
                                        ProxyService.database.insert(data: {
                                          'name': loginResponse.name,
                                          'email': loginResponse.email,
                                          'token': loginResponse.token,
                                          'table': AppTables.user,
                                          'userId': loginResponse.id.toString(),
                                          'expiresAt': loginResponse.expiresAt,
                                          'id': loginResponse.id.toString(),
                                        });
                                        ProxyService.sharedPref.setUserLoggedIn(
                                            userId:
                                                loginResponse.id.toString());

                                        _navigationService.navigateTo(
                                          Routing.signUpView,
                                          arguments: SignUpViewArguments(
                                              name: loginResponse.name,
                                              avatar: loginResponse.avatar,
                                              email: loginResponse.email,
                                              token: loginResponse.token,
                                              userId:
                                                  loginResponse.id.toString()),
                                        );
                                      }
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
}
