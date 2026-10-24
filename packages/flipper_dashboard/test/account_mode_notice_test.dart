import 'package:flipper_dashboard/flipper_app.dart';
import 'package:flipper_models/account_mode/account_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  bool announce({
    AccountMode? before = AccountMode.personal,
    AccountMode now = AccountMode.business,
    bool here = false,
    Duration shown = const Duration(minutes: 5),
  }) => shouldAnnounceModeSwitch(
    before: before,
    now: now,
    switchedHere: here,
    shownFor: shown,
  );

  test('a switch made on another device is announced', () {
    expect(announce(), isTrue);
    expect(
      announce(before: AccountMode.business, now: AccountMode.personal),
      isTrue,
    );
  });

  test('not a change, made here, or right after login: silent', () {
    expect(announce(now: AccountMode.personal), isFalse);
    expect(announce(here: true), isFalse);
    expect(announce(before: null), isFalse);
    expect(announce(shown: const Duration(seconds: 3)), isFalse);
  });
}
