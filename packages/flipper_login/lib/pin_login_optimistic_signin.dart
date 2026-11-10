import 'package:flipper_models/exceptions.dart';

/// Shows the signed-in state at once, then runs [login], and takes that state
/// back if [login] fails.
///
/// While the PIN screen shows itself as signed in, its keypad, PIN field and
/// Sign-in button are disabled. Left that way after a failed login (a timeout,
/// no network, a server error), the user could not try again without
/// restarting the app. A [LoginChoicesException] is a signed-in user moving on
/// to pick a business, so the state stays.
Future<void> signInOptimistically({
  required void Function(bool signedIn) setSignedIn,
  required Future<void> Function() login,
}) async {
  setSignedIn(true);
  try {
    await login();
  } catch (e) {
    if (e is! LoginChoicesException) setSignedIn(false);
    rethrow;
  }
}
