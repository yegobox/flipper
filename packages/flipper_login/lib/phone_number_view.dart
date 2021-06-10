library flipper_login;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/view_models/login_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_login/otp_view.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:universal_platform/universal_platform.dart';

final isWindows = UniversalPlatform.isWindows;

class PhoneNumberView extends StatefulWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  _PhoneNumberViewState createState() => _PhoneNumberViewState();
}

class _PhoneNumberViewState extends State<PhoneNumberView> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return SingleChildScrollView(
          child: Form(
            key: PhoneNumberView._formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 30,
              ),
              RichText(
                  text: TextSpan(children: [
                const TextSpan(text: 'Welcome To'),
                TextSpan(
                    text: ' FLIPPER',
                    style: TextStyle(color: Colors.blue.shade900)),
                const TextSpan(text: ''),
              ], style: const TextStyle(color: Colors.black))),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 12,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue, width: 0.2),
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
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
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
                            decoration: const InputDecoration(
                              focusColor: Colors.black,
                              border: InputBorder.none,
                              hintText: '788 3600 58',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Sen',
                                fontSize: 18,
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
                              title: 'SIGN IN',
                              onTap: () async {
                                if (PhoneNumberView._formKey.currentState!
                                    .validate()) {
                                  //TODOmore phone validation to come!
                                  model.setPhoneNumber(
                                      phone: phoneController.value.text);
                                  final phoneAuth =
                                      await model.login(context: context);
                                  if (isWindows && phoneAuth) {
                                    ProxyService.nav.back();
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: Container(
                                            child: OtpView(),
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
                                }
                              },
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
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
        );
      },
    );
  }
}
