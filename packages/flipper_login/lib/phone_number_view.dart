library flipper_login;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_view_models/login_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_login/otp_view.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final isWindows = UniversalPlatform.isWindows;

class PhoneNumberView extends StatefulWidget {
  @override
  _PhoneNumberViewState createState() => _PhoneNumberViewState();
}

class _PhoneNumberViewState extends State<PhoneNumberView> {
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.w, 40.w, 10.h, 10.h),
          child: Container(
            color: Colors.white,
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: 'Welcome to',
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      TextSpan(
                          text: ' FLIPPER',
                          style: TextStyle(
                              color: Colors.blue.shade900, fontSize: 14.sp)),
                      const TextSpan(text: ''),
                    ], style: const TextStyle(color: Colors.black))),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 12.w,
                        right: 12.w,
                        bottom: 12.w,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.blue, width: 0.2.w),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  offset: const Offset(2, 1),
                                  blurRadius: 2)
                            ]),
                        child: Row(
                          children: [
                            CountryCodePicker(
                              initialSelection: 'RW',
                              textStyle: TextStyle(fontSize: 18.sp),
                              favorite: ['+250', 'RWF'],
                              showFlagDialog: true,
                              onChanged: (code) {
                                model.setCountryIso(iso: code);
                              },
                              showOnlyCountryWhenClosed: false,
                              comparator: (a, b) => b.name!.compareTo(a.name!),
                              onInit: (code) {
                                model.setCountryIso(iso: code);
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0.w),
                                child: TextFormField(
                                  key: Key('phoneField'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Phone number is required';
                                    }
                                    if (value.length < 9 || value.length > 9) {
                                      return 'Phone number is invalid';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.phone,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: Colors.black),
                                  controller: phoneController,
                                  decoration: InputDecoration(
                                    focusColor: Colors.black,
                                    border: InputBorder.none,
                                    hintText: '788 3600 58',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Sen',
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'After entering your phone number, click on verify to authenticate yourself! Then wait up to 20 seconds to get the OTP and proceed',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: !model.loginStart
                                ? BoxButton(
                                    key: Key('signIn'),
                                    title: 'SIGN IN',
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        model.setPhoneNumber(
                                            phone: phoneController.value.text);
                                        final phoneAuth =
                                            await model.login(context: context);
                                        if (isWindows && phoneAuth) {
                                          ProxyService.nav.back();
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          10.0)),
                                            ),
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding: MediaQuery.of(context)
                                                    .viewInsets,
                                                child: Container(
                                                  child: OtpView(),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                  )
                                : Padding(
                                    key: Key('busyButon'),
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 60,
                                      child: BoxButton(
                                        title: 'SIGN IN',
                                        busy: true,
                                      ),
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
