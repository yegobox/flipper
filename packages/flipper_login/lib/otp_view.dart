library flipper_login;

import 'package:flipper_view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';

class OtpView extends StatefulWidget {
  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              key: Key('optForm'),
              child: Form(
                key: _formKey,
                child: Container(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10.w, 180.h, 10.w, 10.w),
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
                                  margin: EdgeInsets.fromLTRB(
                                      2.5.w, 0.h, 2.5.w, 0.w),
                                  child: Text(
                                    'Enter',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      2.5.w, 0.h, 2.5.w, 0.w),
                                  child: Text(
                                    'Code Received',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      2.5.w, 0.h, 2.5.w, 0.h),
                                  child: const Text(
                                    '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ]),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.w, 0.w, 0.w, 40.w),
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
                                    key: Key('otpField'),
                                    textInputType: TextInputType.phone,
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
                                  key: Key('verifyOtp'),
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      model.setOtp(
                                          ot: otpController.value.text);
                                      try {
                                        model.fb.confirmOtp();
                                      } catch (e) {
                                        showSimpleNotification(
                                          Text(e.toString()),
                                          background: Colors.green,
                                          position: NotificationPosition.bottom,
                                        );
                                      }
                                    }
                                  },
                                  title: 'Verify',
                                ),
                              )
                            : Padding(
                                padding:
                                    EdgeInsets.only(left: 8.0.w, right: 8.w),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 60.h,
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
              ),
            ),
          ),
        );
      },
    );
  }
}
