import 'package:flipper_ai_feature/src/models/flo_ai_mode.dart';
import 'package:flipper_ai_feature/src/widgets/flo/flo_model_selector.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupFlipperAppLocalizations(const Locale('en'));

  Future<List<FloAiMode>> pump(
    WidgetTester tester, {
    required bool localAvailable,
    required bool claudeAvailable,
    FloAiMode mode = FloAiMode.cloud,
  }) async {
    final picked = <FloAiMode>[];
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Scaffold(
        body: Center(
          child: FloModelSelector(
            localAvailable: localAvailable,
            claudeAvailable: claudeAvailable,
            mode: mode,
            onChanged: picked.add,
          ),
        ),
      ),
    ));
    return picked;
  }

  testWidgets('with nothing to switch to, a static Cloud pill is shown',
      (tester) async {
    await pump(tester, localAvailable: false, claudeAvailable: false);

    expect(find.text(l10n.floModeCloud), findsOneWidget);
    expect(find.byType(PopupMenuButton<FloAiMode>), findsNothing);
    expect(find.byIcon(Icons.expand_more), findsNothing);
  });

  testWidgets('Claude alone is offered next to Cloud and can be picked',
      (tester) async {
    final picked =
        await pump(tester, localAvailable: false, claudeAvailable: true);

    expect(find.byIcon(Icons.expand_more), findsOneWidget);
    await tester.tap(find.text(l10n.floModeCloud));
    await tester.pumpAndSettle();

    expect(find.text(l10n.floClaudeSubtitle), findsOneWidget);
    expect(find.text(l10n.floCloudSubtitle), findsOneWidget);
    expect(find.text(l10n.floOnDeviceSubtitle), findsNothing);
    // Cloud is the current mode, so only it carries the check.
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(find.text(l10n.floModeClaude));
    await tester.pumpAndSettle();
    expect(picked, [FloAiMode.claude]);
  });

  testWidgets('all three modes list in enum order, current one in the pill',
      (tester) async {
    final picked = await pump(
      tester,
      localAvailable: true,
      claudeAvailable: true,
      mode: FloAiMode.claude,
    );

    expect(find.text(l10n.floModeClaude), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome_outlined), findsOneWidget);

    await tester.tap(find.text(l10n.floModeClaude));
    await tester.pumpAndSettle();
    final titles = [l10n.floModeCloud, l10n.floModeOnDevice]
        .map((t) => tester.getTopLeft(find.text(t).last).dy)
        .toList();
    final claudeY = tester.getTopLeft(find.text(l10n.floClaudeSubtitle)).dy;
    expect(titles[0], lessThan(titles[1]));
    expect(titles[1], lessThan(claudeY));

    await tester.tap(find.text(l10n.floModeOnDevice));
    await tester.pumpAndSettle();
    expect(picked, [FloAiMode.onDevice]);
  });

  testWidgets('on-device without Claude hides the Claude option',
      (tester) async {
    await pump(
      tester,
      localAvailable: true,
      claudeAvailable: false,
      mode: FloAiMode.onDevice,
    );

    await tester.tap(find.text(l10n.floModeOnDevice));
    await tester.pumpAndSettle();

    expect(find.text(l10n.floOnDeviceSubtitle), findsOneWidget);
    expect(find.text(l10n.floCloudSubtitle), findsOneWidget);
    expect(find.text(l10n.floClaudeSubtitle), findsNothing);
  });
}
