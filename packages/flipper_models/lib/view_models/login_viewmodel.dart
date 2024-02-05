import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class LoginViewModel extends FlipperBaseModel {
  LoginViewModel();
  final appService = loc.getIt<AppService>();
  final _routerService = locator<RouterService>();
  bool loginStart = false;
  bool otpStart = false;

  String? phoneNumber;
  void setPhoneNumber({required String phone}) {
    phoneNumber = phone;
  }

  String dialCode = '+250';
  void setCountryIso({dynamic iso}) {
    dialCode = (iso != null ? iso.dialCode : '+250')!;
  }

  void setOtp({required String ot}) {
    otpStart = true;
    notifyListeners();
    ProxyService.box.writeString(key: 'otp', value: ot);
  }

  bool isEmail(String input) {
    // Implement your logic to check if input is an email
    // You can use regular expressions or any other email validation mechanism
    // For simplicity, this example checks if the input contains '@'
    return input.contains('@');
  }

  bool _isProceeding = false;

  get isProcessing => _isProceeding;
  Future<void> desktopLogin({
    required String pinCode,
  }) async {
    try {
      setIsprocessing(value: true);

      Pin? pin = await ProxyService.isar.getPin(pin: pinCode);

      // Update local storage values
      ProxyService.box.writeInt(key: 'businessId', value: pin!.businessId);
      ProxyService.box.writeInt(key: 'branchId', value: pin.branchId);
      ProxyService.box.writeString(key: 'userId', value: pin.userId);
      ProxyService.box.writeString(key: 'userPhone', value: pin.phoneNumber);
      ProxyService.box.writeBool(key: 'isAnonymous', value: true);

      // Perform user login
      await ProxyService.isar.login(
        skipDefaultAppSetup: false,
        userPhone: pin.phoneNumber,
      );

      // Clear and re-sign in with Firebase anonymously
      await FirebaseAuth.instance.signOut();

      /// we are no longer signin anonymously
      ///await FirebaseAuth.instance.signInAnonymously();

      String phoneNumber = pin.phoneNumber;
      if (!isEmail(phoneNumber)) {
        // Append '@flipper.rw' to make it an email
        phoneNumber = phoneNumber + '@flipper.rw';
      }
      try {
        // Try to sign in with the provided credentials
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: phoneNumber,
          password: phoneNumber,
        );
      } on FirebaseAuthException catch (e) {
        // Handle authentication exceptions
        if (e.code == 'user-not-found') {
          try {
            // User not found, attempt to create a new account
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: phoneNumber,
              password: phoneNumber,
            );
          } on FirebaseAuthException catch (e) {
            // Handle exceptions during account creation
            if (e.code == 'weak-password') {
              // Password is too weak
              print('Error: The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
              // Account already exists for the provided email
              print('Error: The account already exists for that email.');
            } else {
              // Handle other exceptions during account creation
              print('Error: $e');
            }
          } catch (e) {
            // Handle unexpected errors during account creation
            print('Error: $e');
          }
        } else if (e.code == 'wrong-password') {
          // Wrong password provided for the user
          print('Error: Wrong password provided for that user.');
        } else {
          // Handle other authentication exceptions
          print('Error: $e');
        }
      } catch (e) {
        // Handle unexpected errors during sign-in
        print('Error: $e');
      }

      /// now ling this user with credentials so next time he wont be anonymous
      //NOTE: if (FirebaseAuth.instance.currentUser!.providerData.isEmpty) {
      //   // User is not linked with any providers
      // }
      // Check if a logged-in Firebase user exists
      final auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        // Navigate based on the default app setting
        final defaultApp = ProxyService.box.getDefaultApp();
        if (defaultApp == "2") {
          _routerService.navigateTo(SocialHomeViewRoute());
        } else {
          openDrawer();
        }
      }
    } catch (error) {
      setIsprocessing(value: false);
      throw error;
    }
  }

  void setIsprocessing({required bool value}) {
    _isProceeding = value;
    notifyListeners();
  }
}
