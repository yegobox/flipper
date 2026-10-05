library flipper_login;

import 'package:flutter/material.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_models/view_models/setting_view_model.dart';

final isWindows = UniversalPlatform.isWindows;

class EnableSyncWidget extends StatefulWidget {
  @override
  _EnableSyncWidgetState createState() => _EnableSyncWidgetState();
}

class _EnableSyncWidgetState extends State<EnableSyncWidget> {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BoxInputField(
                    leading: Icon(Icons.email),
                    validatorFunc: (subCode) {
                      // validate if is a gmail email regex
                    },
                    controller: emailController,
                    placeholder: context.flipperL10n.subscriptionEnterCode,
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    context.flipperL10n.subscriptionEnterCodeHint,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        bottom: 20,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: !model.updateStart
                            ? BoxButton(
                                title:
                                    context.flipperL10n.subscriptionSubscribe,
                                onTap: () async {},
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: BoxButton(
                                    title:
                                        context.flipperL10n.subscriptionUpdate,
                                    busy: true,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
