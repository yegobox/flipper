import 'package:flutter/material.dart';
import 'package:flipper_localize/flipper_localize.dart';

import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_models/db_model_export.dart';

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
                      return context.flipperL10n.subscriptionEnterVoucherError;
                    }
                  },
                  controller: _phoneNumber,
                  placeholder: context.flipperL10n.subscriptionEnterVoucher,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  context.flipperL10n.subscriptionActivatePro,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      bottom: 10,
                    ),
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
                              if (_sub.currentState!.validate()) {}
                            },
                            title: context.flipperL10n.subscriptionUpgradeToPro,
                            busy: model.isProcessing,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
