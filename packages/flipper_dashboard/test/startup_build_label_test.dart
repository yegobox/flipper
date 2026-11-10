import 'package:flipper_dashboard/widgets/startup_progress_screen.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_services/app_build_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<String> _pubspec() async => '1.561.0+1756530048';

Future<String> _noPlugin() async => throw Exception('no plugin');

void main() {
  group('AppBuildInfo.labelFor', () {
    test('Store build: msix version and short commit', () async {
      expect(
        await AppBuildInfo.labelFor(
          version: '1.605.0.0',
          commit: '0a9a65fca6a1b2c3d4e5',
          pubspecVersion: _pubspec,
        ),
        'v1.605.0.0 · 0a9a65f',
      );
    });

    test('version without a commit', () async {
      expect(
        await AppBuildInfo.labelFor(
          version: '1.605.0.0',
          commit: '',
          pubspecVersion: _pubspec,
        ),
        'v1.605.0.0',
      );
    });

    test('launcher build: commit only, never the pubspec number', () async {
      expect(
        await AppBuildInfo.labelFor(
          version: '',
          commit: 'abc12',
          pubspecVersion: _pubspec,
        ),
        'build abc12',
      );
    });

    test('local build: pubspec version marked dev', () async {
      expect(
        await AppBuildInfo.labelFor(
          version: '',
          commit: '',
          pubspecVersion: _pubspec,
        ),
        'v1.561.0+1756530048 · dev',
      );
    });

    test('nothing readable: no label', () async {
      expect(
        await AppBuildInfo.labelFor(
          version: '',
          commit: '',
          pubspecVersion: _noPlugin,
        ),
        isNull,
      );
    });
  });

  group('startup screen build label', () {
    Future<void> pump(
      WidgetTester tester,
      Future<String?> Function() load,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: StartupProgressScreen(progress: 0.2, loadBuildLabel: load),
        ),
      );
      await tester.pump();
    }

    testWidgets('shows the release the binary came from', (tester) async {
      var calls = 0;
      await pump(tester, () async {
        calls++;
        return 'v1.605.0.0 · 0a9a65f';
      });
      expect(find.text('v1.605.0.0 · 0a9a65f'), findsOneWidget);

      // The counter rebuilds the column every frame; the lookup runs once.
      await tester.pump(const Duration(seconds: 1));
      expect(calls, 1);
    });

    testWidgets('a failed lookup hides the line, not the screen', (
      tester,
    ) async {
      await pump(tester, () async => throw Exception('boom'));
      expect(find.textContaining('v1.'), findsNothing);
      expect(find.text('Flipper'), findsOneWidget);
    });

    testWidgets('null hides the line', (tester) async {
      await pump(tester, () async => null);
      expect(find.byType(SelectableText), findsNothing);
    });
  });
}
