import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper_login/services/proxy_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flipper_login/otp.dart';
import 'package:redux/redux.dart';

StreamController<String> controller = StreamController<String>();

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;

  TextEditingController phoneNo;
  String smsOTP;

  String errorMessage = '';
  bool firstOpen;
  bool logedIn;
  bool loading = false;
  bool bluetoothSet;

  // ignore: sort_constructors_first
  AuthProvider();

  // ignore: deprecated_member_use
  User get user => _user;

  TextEditingController address = TextEditingController();

  // ignore: sort_constructors_first
  AuthProvider.initialize();

  // ! PHONE AUTH
  Future<void> verifyPhone(BuildContext context, String number) async {
    // print(number);
    // print('here');
    proxyService.loading.add(true);

    final Store<AppState> store = StoreProvider.of<AppState>(context);

    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      proxyService.loading.add(false);
      store.dispatch(OtpCode(otpcode: verId));
      _showModalBottomSheet(context, '+12025550149');
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: '+12025550149', // PHONE NUMBER TO SEND OTP
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential.toString() + 'lets make this work');
          },
          verificationFailed: (FirebaseAuthException exceptio) {
            print('${exceptio.message} + something is wrong');
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } catch (e) {
      handleError(e, context);
      errorMessage = e.toString();
    }
  }

  Future<void> _showModalBottomSheet(BuildContext context, String phone) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            child: OtpPage(
              phone: phone,
            ),
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }

  // ignore: always_declare_return_types
  // ignore: always_specify_types
  // ignore: always_declare_return_types
  handleError(error, BuildContext context) async {
    print(error);
    errorMessage = error.toString();

    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(FocusNode());
        errorMessage = 'Invalid Code';
        break;
      default:
        errorMessage = error.message;
        break;
    }
  }
}
