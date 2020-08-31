import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_login/helpers/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/src/store.dart';
import 'package:flipper_login/otp.dart';


StreamController<String> controller = StreamController<String>();

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider  {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  Status _status = Status.Uninitialized;
  // Firestore _firestore = Firestore.instance;
  final UserServices _userServicse = UserServices();

  TextEditingController phoneNo;
  String smsOTP;
 
  String errorMessage = '';
  bool firstOpen;
  bool logedIn;
  bool loading = false;
  bool bluetoothSet;

  // ignore: sort_constructors_first
  AuthProvider();


  Status get status => _status;
  // ignore: deprecated_member_use
  FirebaseUser get user => _user;

  TextEditingController address = TextEditingController();

  AuthProvider.initialize() {}

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;

    return Future.delayed(Duration.zero);
  }

  // ! PHONE AUTH
  Future<void> verifyPhone(BuildContext context, String number) async {

    final Store<AppState> store = StoreProvider.of<AppState>(context);

    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      store.dispatch(OtpCode(otpcode: verId));
    };
    try {
      await _auth
          .verifyPhoneNumber(
              phoneNumber: number.trim(), // PHONE NUMBER TO SEND OTP
              codeSent:
                  smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
              timeout: const Duration(seconds: 60),
              verificationCompleted: (AuthCredential phoneAuthCredential) {
                print(phoneAuthCredential.toString() + 'lets make this work');
              },
              verificationFailed: (FirebaseAuthException exceptio) {
                print('${exceptio.message} + something is wrong');
              }, codeAutoRetrievalTimeout: (String verificationId) {  }).then((value) => {

        _showModalBottomSheet(context,number)
      });
    } catch (e) {
      handleError(e, context);
      errorMessage = e.toString();
    }
  }

  _showModalBottomSheet(context,String phone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:true,
      builder: (BuildContext context) {
        return Padding(
            padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child:Container(
              child: OtpPage(phone: phone,),
              height: 300,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),);
      },
    );
  }
  handleError(error, BuildContext context) {
    print(error);
    errorMessage = error.toString();

    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        errorMessage = 'Invalid Code';
        // TODO: show invalid code message
        break;
      default:
        errorMessage = error.message;
        break;
    }
  }

  void _createUser({String id, String number}) {
    _userServicse.createUser({
      "id": id,
      "number": number,
      "closeContacts": [],
      "bluetoothAddress": ""
    });
  }

  Future<void> setBluetoothAddress({String id, String bluetoothAddress}) async {
    // if(_userModel == null){
    //   _createUser(id: _user.uid, number: _user.phoneNumber);
    // }
    updateUser({"id": id, "bluetoothAddress": bluetoothAddress});
  }

  void updateUser(Map<String, dynamic> values) {
    _userServicse.updateUserData(values);
  }
}
