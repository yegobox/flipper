import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_dashboard/setting_view_model.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_models/models/models.dart';

final isWindows = UniversalPlatform.isWindows;

class UpdateProfile extends StatefulWidget {
  UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _id = TextEditingController();
  TextEditingController _vacinnationCode = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _livingAt = TextEditingController();
  TextEditingController _cell = TextEditingController();
  TextEditingController _district = TextEditingController();
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                child: BoxInputField(
                  validatorFunc: (name) {
                    // validate if is a gmail email regex
                    if (name.isEmpty) {
                      return 'Please enter your name';
                    }
                  },
                  controller: _name,
                  placeholder: 'Enter Name',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                child: BoxInputField(
                  validatorFunc: (name) {
                    // validate if is a gmail email regex
                    if (name.isEmpty) {
                      return 'Please enter your ID';
                    }
                  },
                  controller: _id,
                  placeholder: 'Enter national ID',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BoxInputField(
                  leading: Icon(Icons.phone),
                  validatorFunc: (name) {
                    // validate if is a gmail email regex
                    if (name.isEmpty) {
                      return 'Please enter your phone';
                    }
                  },
                  controller: _phoneNumber,
                  placeholder: 'Enter Phone',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BoxInputField(
                  leading: Icon(Icons.email),
                  validatorFunc: (email) {
                    // validate if is a gmail email regex
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

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BoxInputField(
                  validatorFunc: (name) {
                    // validate if is a gmail email regex
                    if (name.isEmpty) {
                      return 'Please enter your Vacinnation Code';
                    }
                  },
                  controller: _vacinnationCode,
                  placeholder: 'Vacinnation Code',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BoxInputField(
                  validatorFunc: (name) {
                    // validate if is a gmail email regex
                    if (name.isEmpty) {
                      return 'Please enter where you live';
                    }
                  },
                  controller: _livingAt,
                  placeholder: 'Enter  where you live',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BoxInputField(
                  validatorFunc: (name) {
                    // validate if is a gmail email regex
                    if (name.isEmpty) {
                      return 'Please enter your cell';
                    }
                  },
                  controller: _cell,
                  placeholder: 'Enter cell',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BoxInputField(
                  validatorFunc: (name) {
                    // validate if is a gmail email regex
                    if (name.isEmpty) {
                      return 'Please enter your district';
                    }
                  },
                  controller: _district,
                  placeholder: 'Enter district',
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'Keep guard your information!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              // const SizedBox(height: 10),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: !model.updateStart
                          ? BoxButton(
                              title: 'Update Profile',
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  int businessId =
                                      ProxyService.box.read(key: 'businessId');
                                  Profile profile = new Profile(
                                    businessId: businessId,
                                    nationalId: _id.value.text,
                                    email: emailController.value.text,
                                    name: _name.value.text,
                                    phone: _phoneNumber.value.text,
                                    district: _district.value.text,
                                    cell: _cell.value.text,
                                    livingAt: _livingAt.value.text,
                                    vaccinationCode:
                                        _vacinnationCode.value.text,
                                    country: 'Rwanda',
                                  );
                                  await model.updateProfile(profile: profile);
                                  showSimpleNotification(
                                    Text('Profile updated'),
                                    background: Colors.green,
                                    position: NotificationPosition.bottom,
                                  );
                                  ProxyService.nav.back();
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
                                  title: 'Update Profile',
                                  busy: true,
                                ),
                              ),
                            ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
