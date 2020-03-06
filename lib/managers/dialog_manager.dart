import 'package:flipper/home/widget/loader.dart';
import 'package:flutter/material.dart';

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
}
