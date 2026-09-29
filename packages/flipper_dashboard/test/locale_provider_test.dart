import 'package:flipper_dashboard/providers/locale_provider.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pins the language picker's list against what the app can actually render.
///
/// French was translated in full but missing from [kSelectableLanguages], so no
/// picker — on Windows or anywhere else — ever offered it.
void main() {
  test('every translated language is offered in the picker', () {
    final offered = kSelectableLanguages.map((l) => l.code).toSet();
    final supported = FlipperAppLocalizations.supportedLocales
        .map((l) => l.languageCode)
        .toSet();

    expect(offered, containsAll(<String>['en', 'fr', 'rw', 'sw']));
    expect(
      supported.difference(offered),
      isEmpty,
      reason: 'a translated language the user cannot pick',
    );
    expect(
      offered.difference(supported),
      isEmpty,
      reason: 'a language in the picker the app cannot render',
    );
  });

  test('picker entries are unique', () {
    final codes = kSelectableLanguages.map((l) => l.code).toList();
    expect(codes.toSet().length, codes.length);
  });
}
