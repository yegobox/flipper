library flipper_login;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/view_models/login_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_login/otp_view.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_dashboard/setting_view_model.dart';

final isWindows = UniversalPlatform.isWindows;

class UpdateEmailSetting extends StatefulWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  _UpdateEmailSettingState createState() => _UpdateEmailSettingState();
}

class _UpdateEmailSettingState extends State<UpdateEmailSetting> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) {
        return SingleChildScrollView(
          child: Form(
            key: UpdateEmailSetting._formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BoxInputField(
                  leading: Icon(Icons.email),
                  validatorFunc: () {
                    //TODOadd propper email validation
                    return true;
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
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: !model.updateStart
                          ? BoxButton(
                              title: 'Update Settings',
                              onTap: () async {
                                if (UpdateEmailSetting._formKey.currentState!
                                    .validate()) {
                                  bool updated = await model.updateSettings(
                                      email: emailController.value.text);
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
