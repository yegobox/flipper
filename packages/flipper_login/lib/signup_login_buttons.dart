import 'package:flipper_login/phone_number_view.dart';
import 'package:common_codes/src/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpLoginButton extends StatelessWidget {
  const SignUpLoginButton({Key? key, this.portrait = false}) : super(key: key);
  final bool portrait;

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          key: Key('loginForm'),
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            child: PhoneNumberView(),
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
                    _showModalBottomSheet(context);
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
                          _showModalBottomSheet(context);
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
