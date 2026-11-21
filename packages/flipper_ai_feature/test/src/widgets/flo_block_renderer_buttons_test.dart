import 'package:flipper_ai_feature/src/theme/flo_theme.dart';
import 'package:flipper_ai_feature/src/widgets/flo/flo_block_renderer.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ink_free_button_finders.dart';

Future<void> _pump(
  WidgetTester tester,
  List<Map<String, dynamic>> blocks, {
  FloAskCallback? onAsk,
}) {
  return tester.pumpWidget(MaterialApp(
    localizationsDelegates: FlipperLocalizationDelegates.delegates,
    supportedLocales: FlipperLocalizationDelegates.supportedLocales,
    home: Scaffold(
      body: SingleChildScrollView(
        child: FloBlockRenderer(blocks: blocks, onAsk: onAsk),
      ),
    ),
  ));
}

void main() {
  group('actions block', () {
    testWidgets('primary and secondary buttons paint their own backgrounds',
        (tester) async {
      await _pump(tester, [
        {
          'type': 'actions',
          'items': [
            {'label': 'Open report', 'icon': 'Chart', 'primary': true},
            {'label': 'Share', 'icon': 'Download'},
          ],
        },
      ]);

      final primary = find.text('Open report');
      final secondary = find.text('Share');

      expectPaintedByContainer(tester, primary);
      final primaryBg = backgroundOf(tester, primary);
      expect(primaryBg.gradient, FloTheme.gradBtn);
      expect(primaryBg.color, isNull);
      expect(primaryBg.boxShadow, const [FloTheme.shBlue]);
      expect(tester.widget<Text>(primary).style?.color, Colors.white);

      expectPaintedByContainer(tester, secondary);
      final secondaryBg = backgroundOf(tester, secondary);
      expect(secondaryBg.gradient, isNull);
      expect(secondaryBg.color, FloTheme.surface);
      expect(secondaryBg.border, Border.all(color: FloTheme.lineStrong));
      expect(tester.widget<Text>(secondary).style?.color, FloTheme.ink1);

      // Both stay tappable (the handler is a no-op today).
      expect(tester.widget<InkWell>(buttonInkWell(primary)).onTap, isNotNull);
      await tester.tap(primary);
      await tester.tap(secondary);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('follow-ups block', () {
    testWidgets('a chip paints its border and asks its question on tap',
        (tester) async {
      final asked = <String>[];
      await _pump(
        tester,
        [
          {
            'type': 'followups',
            'items': [
              {'label': 'Why did sales drop?', 'q': 'Why did sales drop?'},
              {'label': 'Top items'},
              'ignored, not a map',
            ],
          },
        ],
        onAsk: asked.add,
      );

      expect(find.text('SUGGESTED FOLLOW-UPS'), findsOneWidget);

      final chip = find.text('Why did sales drop?');
      expectPaintedByContainer(tester, chip);
      final bg = backgroundOf(tester, chip);
      expect(bg.border, Border.all(color: FloTheme.lineStrong));
      expect(
        bg.borderRadius,
        BorderRadius.circular(FloTheme.radiusPill),
      );

      await tester.tap(chip);
      // Without a `q`, the label is the question.
      await tester.tap(find.text('Top items'));
      await tester.pump();

      expect(asked, ['Why did sales drop?', 'Top items']);
    });

    testWidgets('chips are inert when nobody listens', (tester) async {
      await _pump(tester, [
        {
          'type': 'followups',
          'items': [
            {'label': 'Top items'},
          ],
        },
      ]);

      final chip = find.text('Top items');
      expectPaintedByContainer(tester, chip);
      expect(tester.widget<InkWell>(buttonInkWell(chip)).onTap, isNull);
    });
  });
}
