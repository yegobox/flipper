import 'dart:async';

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flipper/model/user.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class AuthWebView extends StatefulWidget {
  AuthWebView({Key key, this.url, this.authType}) : super(key: key);
  final String url;
  final String authType;

  @override
  _AuthWebViewState createState() => _AuthWebViewState();
}

class _AuthWebViewState extends State<AuthWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.close();
    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {});

    _onStateChanged = flutterWebviewPlugin.onStateChanged
        .listen((WebViewStateChanged state) {});
    _onUrlChanged =
        flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      if (mounted) {
        //TODO: change the url on production env.
        if (url.startsWith("https://test.flipper.rw/authorized?")) {
          RegExp accessToken = new RegExp("personal_token=(.*)");
          var token = accessToken.firstMatch(url)?.group(1);

          RegExp name = new RegExp("name=(.*)");
          var _name = name.firstMatch(url)?.group(1);

          RegExp email = new RegExp("email=(.*)");
          var _email = email.firstMatch(url)?.group(1);

          RegExp avatar = new RegExp("avatar=(.*)");
          var _avatar = avatar.firstMatch(url)?.group(1);

          RegExp userId = new RegExp("id=(.*)");
          var _userId = userId.firstMatch(url)?.group(1);

          final store = StoreProvider.of<AppState>(context);

          User user = User(
            (user) => user
              ..email = _email
              ..active = true
              ..createdAt = DateTime.now().toIso8601String()
              ..updatedAt = DateTime.now().toIso8601String()
              ..token = token
              ..name = _name,
          );
          store.dispatch(UserID(userId: int.parse(_userId)));
          store.dispatch(WithUser(user: user));
          flutterWebviewPlugin.close();

          if (widget.authType == 'register') {
            Router.navigator.pushNamed(
              Router.signUpScreen,
              arguments: SignUpScreenArguments(
                name: _name.split('&')[0],
                avatar: _avatar,
                email: _email.split('&')[0],
                token: token.split('&')[0],
              ),
            );
          } else if (widget.authType == 'login') {
            store.dispatch(VerifyAuthenticationState());
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: widget.url,
        appBar: new AppBar(
          backgroundColor: HexColor("#955be9"),
        ));
  }
}
