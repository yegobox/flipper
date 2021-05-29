library flipper_login;

import 'package:flipper_models/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';

class OtpView extends StatefulWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return Form(
          key: OtpView._formKey,
          child: Container(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.fromLTRB(2.5, 0, 2.5, 0),
                            child: const Text(
                              'Enter',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(2.5, 0, 2.5, 0),
                            child: const Text(
                              'Otp Received',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(2.5, 0, 2.5, 0),
                            child: const Text(
                              '',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: Form(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: BoxInputField(
                              controller: otpController,
                              leading: Icon(Icons.password),
                              placeholder: 'Enter OTP Code',
                              validatorFunc: (value) {
                                if (value!.isEmpty) {
                                  return 'Otp is required';
                                }
                                return null;
                              },
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  !model.otpStart
                      ? Container(
                          child: BoxButton(
                            onTap: () {
                              if (OtpView._formKey.currentState!.validate()) {
                                model.setOtp(ot: otpController.value.text);
                                model.fb.verifyWithOtp();
                              }
                            },
                            title: 'Verify',
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: BoxButton(
                              title: 'Otp',
                              busy: true,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
