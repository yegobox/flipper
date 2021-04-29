library flipper_login;

import 'package:flipper_models/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'button_view.dart';
import 'otp_view.form.dart';

@FormView(fields: [
  FormTextField(name: 'otp'),
])
class OtpView extends StatelessWidget with $OtpView {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        builder: (context, model, child) {
          return Form(
            key: _formKey,
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
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: otpController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Otp is required';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Otp Received by SMS',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   child: const Text(
                    //     'Otp',
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(color: Colors.grey),
                    //   ),
                    // ),
                    Container(
                      child: ButtonView(
                        'Verify',
                        () {
                          if (_formKey.currentState!.validate()) {
                            model.setOtp(ot: otpController.value.text);
                            model.fb.verifyWithOtp();
                          }
                        },
                        Colors.white,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
