import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/ui/welcome/settings/privacy_settings_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'auth_button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Flipper inc', style: const TextStyle(color: Colors.black)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: _LoginForm(),
            ),
            const PrivacySettingsButton(),
          ],
        ),
      ),
    );
  }
}

// MARK: Login Form

class _LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<_LoginForm> {
  @override
  Widget build(BuildContext context) {
    final submitCallback = () async {
      StoreProvider.of<AppState>(context).dispatch(AfterLoginAction());
      //stop faking
    };

    final submitButton = AuthButton(
        buttonText: 'Login with yegobox?', onPressedCallback: submitCallback);

    return Form(
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: submitButton,
          )
        ],
      ),
    );
  }
}
