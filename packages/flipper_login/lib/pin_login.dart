import 'dart:developer';

import 'package:flipper_dashboard/widgets/back_button.dart' as back;
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PinLogin extends StatefulWidget {
  PinLogin({Key? key}) : super(key: key);

  @override
  State<PinLogin> createState() => _PinLoginState();
}

class _PinLoginState extends State<PinLogin> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController _pin = TextEditingController();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                SizedBox(width: 85, child: back.BackButton()),
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
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                      labelStyle: primaryTextStyle,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isObscure
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        },
                                      ),
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
                                  child: !model.isProcessing
                                      ? BoxButton(
                                          key: const Key("pinLoginButton"),
                                          borderRadius: 2,
                                          onTap: () async {
                                            if (_form.currentState!
                                                .validate()) {
                                              try {
                                                log("initiating pin login flow");
                                                await model.desktopLogin(
                                                  pinCode: _pin.text,
                                                );
                                              } catch (e) {
                                                if (e
                                                    is BusinessNotFoundException) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      width: 250,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                        "Pin not found.",
                                                        style: primaryTextStyle,
                                                      ),
                                                    ),
                                                  );
                                                } else if (e
                                                    is ErrorReadingFromYBServer) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      width: 250,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(e.term),
                                                    ),
                                                  );
                                                } else {
                                                  log(e.toString());
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      width: 250,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.red,
                                                      content:
                                                          Text(e.toString()),
                                                    ),
                                                  );
                                                }
                                                model.setIsprocessing(
                                                    value: false);
                                              }
                                            }
                                          },
                                          title: 'Log in',
                                          busy: model.isProcessing,
                                        )
                                      : const Padding(
                                          key: Key('busyButton'),
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: BoxButton(
                                              title: 'Log in',
                                              busy: true,
                                            ),
                                          ),
                                        ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
