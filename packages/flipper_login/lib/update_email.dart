library flipper_login;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_dashboard/setting_view_model.dart';

final isWindows = UniversalPlatform.isWindows;

class UpdateEmailSetting extends StatefulWidget {
  @override
  _UpdateEmailSettingState createState() => _UpdateEmailSettingState();
}

class _UpdateEmailSettingState extends State<UpdateEmailSetting> {
  TextEditingController emailController = TextEditingController();
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BoxInputField(
                  leading: Icon(Icons.email),
                  validatorFunc: (email) {
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email)) {
                      return "Invalid Email";
                    }
                  },
                  controller: emailController,
                  placeholder: 'Enter Email',
                ),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'After entering your email number, click on update settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: !model.updateStart
                          ? BoxButton(
                              title: 'Update Settings',
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  bool updated = await model.updateSettings(
                                    map: {'email': emailController.value.text},
                                  );
                                  if (updated) {
                                    ProxyService.nav.back();
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
                                  title: 'Update Settings',
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
