import 'package:flipper_dashboard/setting_view_model.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_ui/google_ui.dart';
import 'package:stacked/stacked.dart';

class PinLogin extends StatelessWidget {
  PinLogin({Key? key}) : super(key: key);
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pin = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 100.0, 8.0, 0.0),
                child: Column(
                  children: [
                    GTextFormField(
                      labelText: "Enter your PIN",
                      passwordField: true,
                      controller: _pin,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "PIN is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      color: Colors.white70,
                      width: double.infinity,
                      height: 40,
                      child: BoxButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            model.desktopLogin(
                                pinCode: _pin.text,
                                context: context,
                                call: (e) {
                                  if (e == 1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.red,
                                        content:
                                            Text("Failed to log in try again"),
                                      ),
                                    );
                                    model.setIsprocessing(value: false);
                                  }
                                });
                          }
                        },
                        title: 'Log in',
                        busy: model.isProcessing,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
