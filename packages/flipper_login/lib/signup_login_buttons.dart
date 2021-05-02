import 'package:flipper_login/phone_number_view.dart';
import 'package:flipper_models/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SignUpLoginButton extends StatelessWidget {
  const SignUpLoginButton({Key? key, this.portrait = false}) : super(key: key);
  final bool portrait;

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Container(
            child: PhoneNumberView(),
            // height: 400,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
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
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: FlatButton(
                      key: Key('createAccountButton'),
                      onPressed: () {
                        _showModalBottomSheet(context);
                      },
                      color: Colors.blue,
                      child: Text(
                        'Create Account',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
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
                  child: OutlineButton(
                    color: Colors.blue,
                    child: Text(
                      'Sign in',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.blue),
                    ),
                    onPressed: () {
                      _showModalBottomSheet(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
