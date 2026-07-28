import 'dart:convert';
import 'dart:io';

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/cupertino.dart' show CupertinoLocalizations;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the two ways Flipper's localization has silently broken before:
///
///  1. A supported locale with no `flutter_localizations` bundle (Kinyarwanda)
///     leaves `MaterialLocalizations` null, so [Drawer] / [PopupMenuButton] and
///     every date picker throw `No MaterialLocalizations found` on build.
///  2. A translation ARB drifts behind `app_en.arb` and the untranslated keys
///     quietly render in English.
void main() {
  group('framework localizations', () {
    for (final locale in FlipperLocalizationDelegates.supportedLocales) {
      testWidgets('${locale.languageCode}: Material/Cupertino/Widgets resolve',
          (tester) async {
        late BuildContext capturedContext;

        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(
          Localizations.of<MaterialLocalizations>(
            capturedContext,
            MaterialLocalizations,
          ),
          isNotNull,
          reason: 'MaterialLocalizations missing for $locale — widgets that '
              'call debugCheckHasMaterialLocalizations will throw',
        );
        expect(
          Localizations.of<CupertinoLocalizations>(
            capturedContext,
            CupertinoLocalizations,
          ),
          isNotNull,
        );
        expect(
          Localizations.of<WidgetsLocalizations>(
            capturedContext,
            WidgetsLocalizations,
          ),
          isNotNull,
        );
      });

      testWidgets('${locale.languageCode}: a Drawer builds', (tester) async {
        // Drawer is the widget that surfaced the Kinyarwanda crash in the real
        // app, so assert it specifically rather than only the lookup above.
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: Scaffold(
              drawer: const Drawer(child: SizedBox.shrink()),
              body: const SizedBox.shrink(),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    }
  });

  group('translation coverage', () {
    final l10nDir = Directory('lib/l10n');
    final template = _messageKeys(File('${l10nDir.path}/app_en.arb'));

    test('app_en.arb is non-empty', () {
      expect(template, isNotEmpty);
    });

    for (final code in ['rw', 'sw', 'fr']) {
      test('app_$code.arb covers every template key', () {
        final translated = _messageKeys(File('${l10nDir.path}/app_$code.arb'));
        expect(
          template.difference(translated),
          isEmpty,
          reason: 'app_$code.arb is missing keys — they will render in English',
        );
        expect(
          translated.difference(template),
          isEmpty,
          reason: 'app_$code.arb has keys app_en.arb does not define',
        );
      });
    }
  });
}

/// Message keys in an ARB file, excluding `@`-prefixed metadata.
Set<String> _messageKeys(File file) {
  final decoded = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return decoded.keys.where((key) => !key.startsWith('@')).toSet();
}
