import 'package:flipper_ui/dialogs/main.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_models/isar_models.dart';

final isWindows = UniversalPlatform.isWindows;

class SubscriptionWidget extends StatefulWidget {
  const SubscriptionWidget({Key? key}) : super(key: key);

  @override
  _SubscriptionWidgetState createState() => _SubscriptionWidgetState();
}

class _SubscriptionWidgetState extends State<SubscriptionWidget> {
  final TextEditingController _phoneNumber = TextEditingController();
  final GlobalKey<FormState> _sub = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      key: const Key('subscription'),
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) {
        return Form(
          key: _sub,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BoxInputField(
                  leading: const Icon(Icons.monetization_on_sharp),
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
                            onTap: () {
                              if (_sub.currentState!.validate()) {
                                model.activateFlipperPro(
                                  _phoneNumber.text,
                                  (success) {
                                    if (success == 0) {
                                      FlipperDialogs.showSuccessDialog(
                                          context,
                                          'Success',
                                          'Your flipper pro has been activated');
                                      // wait 5 seconds and pop navigation
                                      Future.delayed(const Duration(seconds: 5),
                                          () {
                                        Navigator.pop(context);
                                      });
                                    } else {
                                      FlipperDialogs.showErrorDialog(context,
                                          'Error', 'Something went wrong');
                                    }
                                  },
                                );
                              }
                            },
                            title: 'Upgrade to Pro',
                            busy: model.isProcessing,
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
