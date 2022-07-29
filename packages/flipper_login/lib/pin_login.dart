import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/widgets/back_button.dart' as back;

class PinLogin extends StatelessWidget {
  PinLogin({Key? key}) : super(key: key);
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _pin = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              const back.BackButton(),
              Center(
                child: Form(
                  key: _form,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 300,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 100.0, 8.0, 0.0),
                          child: Column(
                            children: [
                              TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    enabled: true,
                                    border: const OutlineInputBorder(),
                                    labelText: "Enter your PIN"),
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
                                  onTap: () async {
                                    if (_form.currentState!.validate()) {
                                      try {
                                        await model.desktopLogin(
                                          pinCode: _pin.text,
                                          context: context,
                                        );
                                      } catch (e) {
                                        log("PinLogin" + e.toString());
                                        if (e is NotFoundException) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  "Failed to authenticate try again, Business not found."),
                                            ),
                                          );
                                        }
                                        if (e is ErrorReadingFromYBServer) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  "Failed to read server! try again"),
                                            ),
                                          );
                                        }
                                        model.setIsprocessing(value: false);
                                      }
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
                      // const Positioned(
                      //   bottom: 0,
                      //   child: Text('Product of yegobox ltd'),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
