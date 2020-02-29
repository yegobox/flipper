import 'dart:async';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CustomWebView extends StatefulWidget {
  CustomWebView({Key key, this.url}) : super(key: key);
  final String url;

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
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
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
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

          flutterWebviewPlugin.close();
          Router.navigator.pushNamed(
            Router.signUpScreen,
            arguments: SignUpScreenArguments(
              name: _name.split('&')[0],
              avatar: _avatar,
              email: _email.split('&')[0],
              token: token.split('&')[0],
            ),
          );
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
