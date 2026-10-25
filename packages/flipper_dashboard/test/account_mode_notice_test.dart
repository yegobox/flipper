import 'package:flipper_dashboard/flipper_app.dart';
import 'package:flipper_models/account_mode/account_mode.dart';
import 'package:flipper_models/account_mode/account_mode_providers.dart';
import 'package:flutter_test/flutter_test.dart';

AccountModeReading server(AccountMode mode) => (mode: mode, fromServer: true);
AccountModeReading cached(AccountMode mode) => (mode: mode, fromServer: false);

void main() {
  bool announce({
    AccountModeReading? before = (mode: AccountMode.personal, fromServer: true),
    AccountModeReading now = (mode: AccountMode.business, fromServer: true),
    bool here = false,
  }) => shouldAnnounceModeSwitch(before: before, now: now, switchedHere: here);

  test('a switch made on another device is announced', () {
    expect(announce(), isTrue);
    expect(
      announce(
        before: server(AccountMode.business),
        now: server(AccountMode.personal),
      ),
      isTrue,
    );
  });

  test('not a change, made here, or no value before: silent', () {
    expect(announce(now: server(AccountMode.personal)), isFalse);
    expect(announce(here: true), isFalse);
    expect(announce(before: null), isFalse);
  });

  test('the first server reading is a baseline, however late it arrives', () {
    // The cached fallback said personal; the first Ditto result says
    // business (a switch made before this login). Not announced.
    expect(
      announce(
        before: cached(AccountMode.personal),
        now: server(AccountMode.business),
      ),
      isFalse,
    );
  });

  test('a cached fallback never counts (e.g. after the provider rebuilds)', () {
    expect(
      announce(
        before: server(AccountMode.personal),
        now: cached(AccountMode.business),
      ),
      isFalse,
    );
    expect(
      announce(
        before: cached(AccountMode.personal),
        now: cached(AccountMode.business),
      ),
      isFalse,
    );
  });

  test('a later server change is announced at once, with no settling time', () {
    // Baseline, then a genuine change from another device right after.
    final baseline = server(AccountMode.business);
    expect(
      announce(before: cached(AccountMode.business), now: baseline),
      isFalse,
    );
    expect(
      announce(before: baseline, now: server(AccountMode.personal)),
      isTrue,
    );
  });
}
