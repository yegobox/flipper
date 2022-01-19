import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_dashboard/setting_view_model.dart';

final isWindows = UniversalPlatform.isWindows;

class SubscriptionWidget extends StatefulWidget {
  SubscriptionWidget({Key? key}) : super(key: key);

  @override
  _SubscriptionWidgetState createState() => _SubscriptionWidgetState();
}

class _SubscriptionWidgetState extends State<SubscriptionWidget> {
  TextEditingController _phoneNumber = TextEditingController();
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
                padding: const EdgeInsets.all(8.0),
                child: BoxInputField(
                  leading: Icon(Icons.monetization_on_sharp),
                  validatorFunc: (name) {
                    // validate if is a gmail email regex
                    if (name.isEmpty) {
                      return 'Please enter your voucher';
                    }
                  },
                  controller: _phoneNumber,
                  placeholder: 'Enter Voucher',
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'Activate flipper pro!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
