import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_login/helpers/user.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper/domain/redux/app_state.dart';
import '../otp.dart';
import 'package:flutter_redux/flutter_redux.dart';


StreamController<String> controller = StreamController<String>();
Stream loginStream = controller.stream;

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  Status _status = Status.Uninitialized;
  // Firestore _firestore = Firestore.instance;
  UserServices _userServicse = UserServices();

  TextEditingController phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  bool firstOpen;
  bool logedIn;
  bool loading = false;
  bool bluetoothSet;

  AuthProvider();


  Status get status => _status;
  FirebaseUser get user => _user;

  TextEditingController address = TextEditingController();

  AuthProvider.initialize() {}

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  // ! PHONE AUTH
  Future<void> verifyPhone(BuildContext context, String number) async {

    final store = StoreProvider.of<AppState>(context);

    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      store.dispatch(OtpCode(otpcode: verificationId));
    };
    try {
      await _auth
          .verifyPhoneNumber(
              phoneNumber: number.trim(), // PHONE NUMBER TO SEND OTP
              codeAutoRetrievalTimeout: (String verId) {
                //Starts the phone number verification process for the given phone number.
                //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
                this.verificationId = verId;
              },
              codeSent:
                  smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
              timeout: const Duration(seconds: 20),
              verificationCompleted: (AuthCredential phoneAuthCredential) {
                print(phoneAuthCredential.toString() + "lets make this work");
              },
              verificationFailed: (exceptio) {
                print('${exceptio.message} + something is wrong');
              }).then((value) => {

          store.dispatch(NavigateOtp(navigate: 'otp',phone: number))
          //todo: dispatch action to close a model.
      });
    } catch (e) {
      handleError(e, context);
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  signIn(BuildContext context) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final user = await _auth.signInWithCredential(credential);
      // final FirebaseUser currentUser = await _auth.currentUser();
      // assert(user.user.uid == currentUser.uid);

      logedIn = true;
      if (user != null) {
        //  todo:here

        loading = false;
        if (bluetoothSet) {
          // changeScreenReplacement(context, Home());
        } else {
          // changeScreenReplacement(context, BluetoothAddress());
        }
      }
      loading = false;

      Navigator.of(context).pop();
      // changeScreenReplacement(context, Home());
      notifyListeners();
    } catch (e) {
      handleError(e, context);
    }
  }

  handleError(error, BuildContext context) {
    print(error);
    errorMessage = error.toString();
    notifyListeners();
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
    notifyListeners();
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
