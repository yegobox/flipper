import 'package:flipper_models/models/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          margin: EdgeInsets.only(top: 50.h),
          child: Column(
            children: <Widget>[
              Padding(
                key: Key('createAccountButton'),
                padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 0.h),
                child: BoxButton(
                  title: 'Create Account',
                  onTap: () {
                    if (!widget.isSystemTimeSet) {
                      showSimpleNotification(
                          Text("Please set your device time to automatic"),
                          background: Colors.green,
                          duration: Duration(minutes: 2));
                    } else {
                      _showModalBottomSheet(context);
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 20.h),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: BoxButton.outline(
                        title: 'SIGN IN',
                        onTap: () {
                          if (!widget.isSystemTimeSet) {
                            showSimpleNotification(
                                Text(
                                    "Please set your device time to automatic"),
                                background: Colors.green,
                                duration: Duration(minutes: 2));
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
