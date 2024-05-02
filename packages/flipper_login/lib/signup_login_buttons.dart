import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';

import 'package:overlay_support/overlay_support.dart';

class SignUpLoginButton extends StatefulWidget {
  const SignUpLoginButton(
      {Key? key, this.portrait = false, required this.isSystemTimeSet})
      : super(key: key);
  final bool portrait;
  final bool isSystemTimeSet;

  @override
  State<SignUpLoginButton> createState() => _SignUpLoginButtonState();
}

class _SignUpLoginButtonState extends State<SignUpLoginButton> {
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          key: const Key('loginForm'),
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            child: const SizedBox(),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return Container(
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[
              Padding(
                key: const Key('createAccountButton'),
                padding: const EdgeInsets.only(left: 18, right: 18, top: 0),
                child: BoxButton(
                  title: 'Create Account',
                  onTap: () {
                    if (!widget.isSystemTimeSet) {
                      showSimpleNotification(
                          const Text(
                              "Please set your device time to automatic"),
                          background: Colors.green,
                          duration: const Duration(minutes: 2));
                    } else {
                      _showModalBottomSheet(context);
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 18, right: 18, top: 20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: BoxButton.outline(
                        title: 'SIGN IN',
                        onTap: () {
                          if (!widget.isSystemTimeSet) {
                            showSimpleNotification(
                                const Text(
                                    "Please set your device time to automatic"),
                                background: Colors.green,
                                duration: const Duration(minutes: 2));
                          } else {
                            _showModalBottomSheet(context);
                          }
                        },
                      ),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
