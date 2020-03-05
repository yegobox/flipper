import 'dart:convert';
import 'dart:io';

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;

class Subscription extends StatefulWidget {
  Subscription(
      {Key key, this.name, this.avatar, this.email, this.token, this.authType})
      : super(key: key);
  final String name;
  final String avatar;
  final String email;
  final String token;
  final String authType;

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlineButton(
          color: Colors.blue,
          child: Text("Subscribe"),
          onPressed: () async {
            final store = StoreProvider.of<AppState>(context);

            http.post("https://test.flipper.rw/api/activate_subscription",
                headers: {
                  HttpHeaders.authorizationHeader:
                      "Bearer " + store.state.user.token
                },
                body: {
                  'subscribed': 'subscribed'
                }).then((dynamic response) {
              final int statusCode = response.statusCode;
              if (statusCode < 200 || statusCode > 400 || json == null) {
                // return;
              }
              print(widget.authType);
              if (widget.authType == 'register') {
                Router.navigator.pushNamed(
                  Router.signUpScreen,
                  arguments: SignUpScreenArguments(
                    name: widget.name,
                    avatar: widget.avatar,
                    email: widget.email,
                    token: widget.token,
                  ),
                );
              } else if (widget.authType == 'login') {
                store.dispatch(VerifyAuthenticationState());
              }
            }).catchError((dynamic onError) {
              print(onError.toString());
            });
          },
        ),
      ),
    );
  }
}
