import 'dart:io';

import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/login/auth_webview.dart';
import 'package:flipper/presentation/splash/popup.dart';
import 'package:flipper/presentation/splash/popup_content.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:query_params/query_params.dart';
import 'package:url_launcher/url_launcher.dart';

class ButtonPortrait extends StatefulWidget {
  const ButtonPortrait({
    Key key,
  }) : super(key: key);

  @override
  _ButtonPortraitState createState() => _ButtonPortraitState();
}

class _ButtonPortraitState extends State<ButtonPortrait> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 2,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 20,
            ),
            Container(
              color: Colors.blue,
              child: SizedBox(
                width: 380,
                height: 60,
                child: FlatButton(
                  onPressed: () async {
                    final URLQueryParams query = URLQueryParams();
                    query.append('client_id', '49');
                    query.append(
                        'redirect_uri', 'https://flipper.rw/auth/callback');
                    query.append('response_type', 'code');
                    query.append('scope', '');
                    query.append('state', '');

                    try {
                      final List<InternetAddress> result =
                          await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        const String url = 'https://flipper.rw/register';
                        if (await canLaunch(url)) {
                          showPopup(
                            context,
                            AuthWebView(
                              authType: 'register',
                              url: url,
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: 'There is a problem launching login url',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    } on SocketException catch (_) {
                      Fluttertoast.showToast(
                          msg: 'you are not connected to internet',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  color: Colors.blue,
                  child: Text(
                    S.of(context).createAccount,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              height: 20,
            ),
            Container(
              color: Colors.white,
              child: SizedBox(
                width: 380,
                height: 60,
                child: OutlineButton(
                  color: Colors.blue,
                  child: Text(
                    S.of(context).signIn,
                    style: const TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: 'Got a click 2..',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );

                    // final URLQueryParams query = URLQueryParams();
                    // query.append('client_id', '49');

                    // query.append('redirect_uri',
                    //     'https://flipper.rw/auth/callback');

                    // query.append('response_type', 'code');
                    // query.append('scope', '');
                    // query.append('state', '');

                    // try {
                    //   final result =
                    //       await InternetAddress.lookup('google.com');
                    //   if (result.isNotEmpty &&
                    //       result[0].rawAddress.isNotEmpty) {
                    //     var url = 'https://flipper.rw/login';
                    //     if (await canLaunch(url)) {
                    //       showPopup(
                    //         context,
                    //         AuthWebView(
                    //           authType: 'login',
                    //           url: url,
                    //         ),
                    //       );
                    //     } else {
                    //       Fluttertoast.showToast(
                    //           msg:
                    //               'There is a problem launching login url',
                    //           toastLength: Toast.LENGTH_LONG,
                    //           gravity: ToastGravity.BOTTOM,
                    //           timeInSecForIos: 1,
                    //           backgroundColor: Colors.red,
                    //           textColor: Colors.white,
                    //           fontSize: 16.0);
                    //     }
                    //   }
                    // } on SocketException catch (_) {
                    //   Fluttertoast.showToast(
                    //       msg: 'There is no internet',
                    //       toastLength: Toast.LENGTH_LONG,
                    //       gravity: ToastGravity.BOTTOM,
                    //       timeInSecForIos: 1,
                    //       backgroundColor: Colors.red,
                    //       textColor: Colors.white,
                    //       fontSize: 16.0);
                    //   return;
                    // }
                  },
                ),
              ),
            ),
            Container(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  showPopup(BuildContext context, Widget widget, {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(
          content: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }
}
