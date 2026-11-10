import 'dart:async';

import 'package:flipper_login/pin_login_optimistic_signin.dart';
import 'package:flipper_models/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

/// A failed PIN login used to leave the screen showing "signed in", with the
/// keypad and Sign-in button disabled until the app was restarted.
void main() {
  late List<bool> states;
  void record(bool signedIn) => states.add(signedIn);

  setUp(() => states = <bool>[]);

  test('a login that succeeds stays signed in', () async {
    await signInOptimistically(setSignedIn: record, login: () async {});
    expect(states, [true]);
  });

  test('a login that fails gives the keypad back and reports the error',
      () async {
    await expectLater(
      signInOptimistically(
        setSignedIn: record,
        login: () async => throw TimeoutException('login'),
      ),
      throwsA(isA<TimeoutException>()),
    );
    expect(states, [true, false]);
  });

  test('moving on to pick a business is not a failure', () async {
    await expectLater(
      signInOptimistically(
        setSignedIn: record,
        login: () async => throw LoginChoicesException(term: 'pick one'),
      ),
      throwsA(isA<LoginChoicesException>()),
    );
    expect(states, [true]);
  });
}
