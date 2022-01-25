library flipper_models;

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_services/abstractions/platform.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/locator.dart';

abstract class AuthenticationViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();

  final firebaseAuthenticationService = locator<LoginStandard>();

  final String successRoute;
  AuthenticationViewModel({required this.successRoute});

  Future<FirebaseAuthenticationResult> runAuthentication();
  Future<void> runPhoneAuthentication();

  Future saveData() async {
    await runBusyFuture(runPhoneAuthentication());
  }

  Future<void> useGoogleAuthentication() async {
    final result = await firebaseAuthenticationService.signInWithGoogle();
    _handleAuthenticationResponse(authResult: result);
  }

  Future<void> usePhoneAuthentication() async {}

  Future<void> useAppleAuthentication() async {
    final result = await firebaseAuthenticationService.signInWithApple(
      appleClientId: '',
      appleRedirectUri:
          'https://boxtout-production.firebaseapp.com/__/auth/handler',
    );
    _handleAuthenticationResponse(authResult: result);
  }

  /// Checks if the result has an error. If it doesn't we navigate to the success view
  /// else we show the friendly validation message.
  void _handleAuthenticationResponse(
      {FirebaseAuthenticationResult? authResult, String type = 'defaut'}) {
    if (type == 'phone') {
      // navigationService.pop();
      //now show another model for otp
      ProxyService.nav.back();
      return;
    }
    if (!authResult!.hasError) {
      // navigate to success route
      navigationService.replaceWith(successRoute);
    } else {
      // setValidationMessage(authResult.errorMessage);
      notifyListeners();
    }
  }
}
