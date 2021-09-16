library flipper_services;

import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stacked_firebase_auth/src/firebase_authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_login/otp_view.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_models/login.dart';
import 'abstractions/platform.dart';

class FlipperFirebaseAuthenticationService extends FirebaseAuthenticationService
    implements LoginStandard {
  verifyOtp({required String otpCode}) {}
  final box = GetStorage();
  ConfirmationResult? confirmationResult;

  @override
  Future<bool> createAccountWithPhone(
      {required String phone, required BuildContext context}) async {
    try {
      if (!UniversalPlatform.isWeb) {
        await firebaseAuth.verifyPhoneNumber(
            phoneNumber: phone,
            codeSent: (verificationId, resendToken) async {
              ProxyService.nav.back();
              box.write('verificationId', verificationId);
              box.write('resendToken', resendToken);

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Container(
                      child: OtpView(),
                      height: 400,
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
            },
            timeout: const Duration(seconds: 60),
            verificationCompleted: (phoneAuthCredential) {
              print(phoneAuthCredential.toString() + 'lets make this work');
            },
            verificationFailed: (exceptio) {
              print('${exceptio.message} + something is wrong');
            },
            codeAutoRetrievalTimeout: (verificationId) {});
        return true;
      } else {
        // print('we are using web thing22::' + phone);
        confirmationResult = await firebaseAuth.signInWithPhoneNumber(phone);
        ProxyService.nav.back();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: Container(
                child: OtpView(),
                height: 400,
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
        return true;
      }

      // ignore: nullable_type_in_catch_clause
    } on FirebaseAuthException catch (e) {
      log?.e('A firebase exception has occured. $e');
      FirebaseAuthenticationResult.error(
          errorMessage: getErrorMessageFromFirebaseException(e));
    } on Exception catch (e) {
      log?.e('A general exception has occured. $e');
      FirebaseAuthenticationResult.error(
          errorMessage:
              'We could not create your account at this time. Please try again.');
    }
    return false;
  }

  @override
  confirmOtpForWeb({required String otp}) async {
    print('now verifying');
    await confirmationResult!.confirm(otp);
  }

  @override
  Future<void> verifyWithOtp() async {
    String? phone = ProxyService.box.read(key: 'userPhone');
    String? otp = ProxyService.box.read(key: 'otp');

    try {
      if (UniversalPlatform.isWeb) {
        confirmOtpForWeb(otp: otp!);
      } else {
        String? verificationId = ProxyService.box.read(key: 'verificationId');
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId!,
          smsCode: otp!,
        );
        final FirebaseAuth auth = FirebaseAuth.instance;
        await auth.signInWithCredential(credential);
      }
    } catch (e) {}
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event != null) {
        Login login = await ProxyService.api.login(phone: phone!);

        ///call api to sync! start by syncing
        ///so that we cover the case when a user synced and deleted app
        ///and come again in this case the API will have sync!
        await ProxyService.api.authenticateWithOfflineDb(
          userId: login.id.toString(),
        );

        //then go startup logic
        ProxyService.nav.navigateTo(Routes.initial);
        //this mark that we are logged in
        ProxyService.box.write(
          key: 'userId',
          value: login.id.toString(),
        );
      }
    });
  }

  @override
  Future<User?> getCurrentUserId() async {
    //get the current firebase user
    if (firebaseAuth.currentUser != null) {
      return firebaseAuth.currentUser;
    }
    return null;
  }
}
