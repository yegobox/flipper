// import 'dart:async';

// import 'package:flipper/data/main_database.dart';
// import 'package:flipper/domain/redux/app_state.dart';
// import 'package:flipper/domain/redux/authentication/auth_actions.dart';
// import 'package:flipper/domain/redux/user/user_actions.dart';
// import 'package:flipper/model/fuser.dart';
// import 'package:flipper/routes/router.gr.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// class AuthWebView extends StatefulWidget {
//   AuthWebView({Key key, this.url, this.authType}) : super(key: key);
//   final String url;
//   final String authType;

//   @override
//   _AuthWebViewState createState() => _AuthWebViewState();
// }

// class _AuthWebViewState extends State<AuthWebView> {
//   final flutterWebviewPlugin = new FlutterWebviewPlugin();

//   StreamSubscription _onDestroy;
//   StreamSubscription<String> _onUrlChanged;
//   StreamSubscription<WebViewStateChanged> _onStateChanged;

//   @override
//   void dispose() {
//     // Every listener should be canceled, the same should be done with this stream.
//     _onDestroy.cancel();
//     _onUrlChanged.cancel();
//     _onStateChanged.cancel();
//     flutterWebviewPlugin.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     flutterWebviewPlugin.close();
//     // Add a listener to on destroy WebView, so you can make came actions.
//     _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {});

//     _onStateChanged = flutterWebviewPlugin.onStateChanged
//         .listen((WebViewStateChanged state) {});
//     _onUrlChanged =
//         flutterWebviewPlugin.onUrlChanged.listen((String url) async {
//       if (mounted) {
//         if (url.startsWith('https://flipper.rw/authorized?')) {
//           RegExp accessToken = new RegExp('personal_token=(.*)');
//           var token = accessToken.firstMatch(url)?.group(1);

//           RegExp name = new RegExp('name=(.*)');
//           var _name = name.firstMatch(url)?.group(1);

//           RegExp email = new RegExp('email=(.*)');
//           var _email = email.firstMatch(url)?.group(1);

//           RegExp avatar = new RegExp('avatar=(.*)');
//           var _avatar = avatar.firstMatch(url)?.group(1);

//           RegExp userId = new RegExp('id=(.*)');
//           var _userId = userId.firstMatch(url)?.group(1);

//           RegExp subs = new RegExp('subscription=(.*)');
//           var _subs = subs.firstMatch(url)?.group(1);

//           flutterWebviewPlugin.close();

//           final store = StoreProvider.of<AppState>(context);

//           final storage = new FlutterSecureStorage();
//           await storage.write(
//               key: 'sync_url', value: 'https://yegobox.com:4984');
//           await storage.write(key: 'sync_database', value: 'main');
//           await storage.write(key: 'db_username', value: 'Administrator');
//           await storage.write(key: 'db_password', value: 'password');
//           //done saving credentials.
//           User user = User(
//             (user) => user
//               ..email = _email.split('&')[0]
//               ..active = true
//               ..createdAt = DateTime.now().toIso8601String()
//               ..updatedAt = DateTime.now().toIso8601String()
//               ..token = token.split('&')[0]
//               ..name = _name.split('&')[0].replaceAll('%20', ' '),
//           );
//           store.dispatch(WithUser(user: user));

//           store.dispatch(UserID(userId: int.parse(_userId.split('&')[0])));
//           UserTableData userExist =
//               await store.state.database.userDao.getUser();
//           if (userExist == null) {
//             await store.state.database.userDao.insertUser(UserTableData(
//                 username: _name.split('&')[0].replaceAll('%20', ' '),
//                 email: _email.split('&')[0],
//                 token: token.split('&')[0],
//                 userId: int.parse(_userId.split('&')[0])));
//           }

//           //check if a user belongs to a subscription then do.
//           if (_subs.split('&')[0] == 'null') {
//             // Routing.navigator.pushNamed(Routing.subscription,
//             //     arguments: SubscriptionArguments(
//             //         name: _name.split('&')[0].replaceAll('%20', ' '),
//             //         email: _email.split('&')[0],
//             //         token: token.split('&')[0],
//             //         authType: widget.authType,
//             //         avatar: _avatar.split('&')[0]));

//             // skipped the subscription check.

//             store.dispatch(VerifyAuthenticationState());
//           } else {
//             if (widget.authType == 'register') {
//               Routing.navigator.pushNamed(
//                 Routing.signUpScreen,
//                 arguments: SignUpScreenArguments(
//                   name: _name.split('&')[0].replaceAll('%20', ''),
//                   avatar: _avatar.split('&')[0],
//                   email: _email.split('&')[0],
//                   token: token.split('&')[0],
//                 ),
//               );
//             } else if (widget.authType == 'login') {
//               //this is to just check subscription will work??
//                Routing.navigator.pushNamed(Routing.subscription,
//                    arguments: SubscriptionArguments(
//                        name: _name.split('&')[0].replaceAll('%20', ' '),
//                        email: _email.split('&')[0],
//                        token: token.split('&')[0],
//                        authType: widget.authType,
//                        avatar: _avatar.split('&')[0]));
//               store.dispatch(VerifyAuthenticationState());
//             }
//           }
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WebviewScaffold(url: widget.url);
//   }
// }
