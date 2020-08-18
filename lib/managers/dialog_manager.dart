import 'package:flipper/home/widget/loader.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Manager {
  static showLoader(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Material(
            type: MaterialType.transparency,
            child: Loader(
              radius: 60.0,
              dotRadius: 6.0,
            ), //put my Loader here
          ),
        );
      },
    );
  }

  static deprecatedNotification() {
    Fluttertoast.showToast(
        msg: 'feature deprecated need re-work',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static dismissDialog() {
    Routing.navigator.pop();
  }
}
