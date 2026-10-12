import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_checkout_footer.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/widgets/mpos/mpos_checkout_footer_test.dart
Future<void> _pump(WidgetTester tester, {String? secondary}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Scaffold(
        body: MposCheckoutFooter(
          total: 1,
          ready: true,
          isLoading: false,
          primaryLabel: 'Complete',
          onSaveTicket: () {},
          onPrimary: () {},
          secondaryLabel: secondary,
          onSecondary: secondary == null ? null : () {},
        ),
      ),
    ),
  );
}

List<BoxDecoration> _buttonDecorations(WidgetTester tester) => tester
    .widgetList<Ink>(find.byType(Ink))
    .map((ink) => ink.decoration)
    .whereType<BoxDecoration>()
    .where((d) => d.gradient != null || d.border != null)
    .toList();

void main() {
  testWidgets('ready Complete is brand blue, never green', (tester) async {
    await _pump(tester);
    final decorations = _buttonDecorations(tester);
    expect(decorations, hasLength(1));
    expect(decorations.single.gradient, MposTokens.gradBtn);
  });

  testWidgets(
    'split MoMo actions: filled blue primary, outlined blue secondary',
    (tester) async {
      await _pump(tester, secondary: 'Charge');
      final decorations = _buttonDecorations(tester);
      expect(
        decorations.where((d) => d.gradient == MposTokens.gradBtn),
        hasLength(1),
      );
      final outlined = decorations.singleWhere((d) => d.border != null);
      expect(outlined.color, PosTokens.blueTint);
      expect((outlined.border! as Border).top.color, PosTokens.blue);
    },
  );
}
