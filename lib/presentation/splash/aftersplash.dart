import 'dart:io';

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
// import 'package:flipper/presentation/login/auth_webview.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:query_params/query_params.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flipper/presentation/splash/popup.dart';
import 'package:flipper/presentation/splash/popup_content.dart';

class AfterSplash extends StatelessWidget {
  aspectButtonPortrait(context) => AspectRatio(
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
                      URLQueryParams query = new URLQueryParams();
                      query.append('client_id', "49");
                      query.append(
                          'redirect_uri', "https://flipper.rw/auth/callback");
                      query.append('response_type', "code");
                      query.append('scope', "");
                      query.append('state', "");

                      try {
                        final result =
                            await InternetAddress.lookup('google.com');
                        if (result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          var url = 'https://flipper.rw/register';
                          if (await canLaunch(url)) {
                            // showPopup(
                            //     context,
                            //     AuthWebView(
                            //       authType: 'register',
                            //       url: url,
                            //     ),
                            //     );
                          } else {
                            Fluttertoast.showToast(
                                msg: "There is a problem launching login url",
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
                            msg: "you are not connected to internet",
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
                      style: TextStyle(color: Colors.white),
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
                  child: StoreConnector<AppState, CommonViewModel>(
                    distinct: true,
                    converter: CommonViewModel.fromStore,
                    builder: (context, vm) {
                      return OutlineButton(
                        color: Colors.blue,
                        child: Text(
                          S.of(context).signIn,
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () async {
                          URLQueryParams query = new URLQueryParams();
                          query.append('client_id', "49");
                          query.append('redirect_uri',
                              "https://flipper.rw/auth/callback");
                          query.append('response_type', "code");
                          query.append('scope', "");
                          query.append('state', "");

                          try {
                            final result =
                                await InternetAddress.lookup('google.com');
                            if (result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              var url = 'https://flipper.rw/login';
                              if (await canLaunch(url)) {
                                // showPopup(
                                //     context,
                                //     AuthWebView(
                                //       authType: 'login',
                                //       url: url,
                                //     ),
                                //     );
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "There is a problem launching login url",
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
                                msg: "There is no internet",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            return;
                          }
                        },
                      );
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

  aspectButtonLandascape(context) => AspectRatio(
        aspectRatio: 5 / 1,
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
                      URLQueryParams query = new URLQueryParams();
                      query.append('client_id', "49");
                      query.append(
                          'redirect_uri', "https://flipper.rw/auth/callback");
                      query.append('response_type', "code");
                      query.append('scope', "");
                      query.append('state', "");

                      try {
                        final result =
                            await InternetAddress.lookup('google.com');
                        if (result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          var url = 'https://flipper.rw/register';
                          if (await canLaunch(url)) {
                            // showPopup(
                            //     context,
                            //     AuthWebView(
                            //       authType: 'register',
                            //       url: url,
                            //     ),);
                          } else {
                            Fluttertoast.showToast(
                                msg: "There is a problem launching login url",
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
                            msg: "you are not connected to internet",
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
                      style: TextStyle(color: Colors.white),
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
                  child: StoreConnector<AppState, CommonViewModel>(
                    distinct: true,
                    converter: CommonViewModel.fromStore,
                    builder: (context, vm) {
                      return OutlineButton(
                        color: Colors.blue,
                        child: Text(
                          S.of(context).signIn,
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () async {
                          URLQueryParams query = new URLQueryParams();
                          query.append('client_id', "49");
                          query.append('redirect_uri',
                              "https://flipper.rw/auth/callback");
                          query.append('response_type', "code");
                          query.append('scope', "");
                          query.append('state', "");
                          try {
                            final insInternetAvailable =
                                await InternetAddress.lookup('google.com');
                            if (insInternetAvailable.isNotEmpty &&
                                insInternetAvailable[0].rawAddress.isNotEmpty) {
                              var url = 'https://flipper.rw/login';
                              if (await canLaunch(url)) {
                                // showPopup(
                                //     context,
                                //     AuthWebView(
                                //       authType: 'login',
                                //       url: url,
                                //     ),);
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "There is a problem launching login url",
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
                                msg: "There is no internet",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            return;
                          }
                        },
                      );
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

  aspectLogoPortrait(context) => AspectRatio(
        aspectRatio: 2 / 2,
        child: Container(
          color: HexColor("#955be9"),
          child: Column(
            children: <Widget>[
              Container(
                height: 80,
              ),
              Container(
                height: 60,
                child: Image.asset("assets/graphics/logo.png"),
              ),
              Container(
                height: 40,
              ),
              Center(
                child: Text(
                  S.of(context).flipperPointofSale,
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
              Text(
                S.of(context).interactandgrowyourbusiness,
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
        ),
      );
  aspectLogoLandiscape(context) => AspectRatio(
        aspectRatio: 3 / 1,
        child: Container(
          color: HexColor("#955be9"),
          child: Column(
            children: <Widget>[
              Container(
                height: 80,
              ),
              Container(
                height: 60,
                child: Image.asset("assets/graphics/logo.png"),
              ),
              Container(
                height: 40,
              ),
              Text(
                S.of(context).flipperPointofSale,
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
              Text(
                S.of(context).interactandgrowyourbusiness,
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var landscape = MediaQuery.of(context).orientation == Orientation.landscape;
    Widget child;
    if (landscape)
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          aspectLogoLandiscape(context),
          aspectButtonLandascape(context)
        ],
      );
    if (!landscape)
      child = Wrap(
        children: <Widget>[
          aspectLogoPortrait(context),
          aspectButtonPortrait(context)
        ],
      );
    return Scaffold(
      body: child,
    );
  }

  showPopup(BuildContext context, Widget widget,
      {BuildContext popupContext}) {
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
