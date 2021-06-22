import 'package:flipper_login/phone_number_view.dart';
import 'package:flipper_models/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';

class SignUpLoginButton extends StatelessWidget {
  const SignUpLoginButton({Key? key, this.portrait = false}) : super(key: key);
  final bool portrait;

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
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
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 0),
                child: BoxButton(
                  title: 'Create Account',
                  onTap: () {
                    _showModalBottomSheet(context);
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 18.0, right: 18.0, top: 20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
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
