// The desktop shell shows system status (tax server / connectivity) as a
// compact strip under the top bar instead of the full-width red AppBar.
//
// Run from `flipper/packages/flipper_dashboard`:
//   flutter test test/pos_system_status_strip_test.dart --dart-define=FLUTTER_TEST_ENV=true

import 'package:flipper_dashboard/widgets/pos_system_status_strip.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    show statusTextProvider;
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Widget _host(String? status) {
  return ProviderScope(
    overrides: [statusTextProvider.overrideWith((ref) => Stream.value(status))],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
      supportedLocales: FlipperAppLocalizations.supportedLocales,
      home: const Scaffold(body: Column(children: [PosSystemStatusStrip()])),
    ),
  );
}

void main() {
  testWidgets('renders nothing while there is no status', (tester) async {
    await tester.pumpWidget(_host(''));
    await tester.pump();
    expect(find.byType(Container), findsNothing);
    expect(find.byKey(const Key('pos-status-tax-settings')), findsNothing);
  });

  testWidgets('tax server down → friendly copy + Tax settings action', (
    tester,
  ) async {
    await tester.pumpWidget(_host(PosSystemStatusStrip.taxServerDownMessage));
    await tester.pump();

    expect(find.textContaining('RRA tax server unreachable'), findsOneWidget);
    expect(find.byKey(const Key('pos-status-tax-settings')), findsOneWidget);
    // Compact: a single 32px strip, not an AppBar.
    final box = tester.getSize(find.byType(PosSystemStatusStrip));
    expect(box.height, PosSystemStatusStrip.height);
    expect(find.byType(AppBar), findsNothing);
  });

  testWidgets('internet down → offline copy, no Tax settings action', (
    tester,
  ) async {
    await tester.pumpWidget(_host(PosSystemStatusStrip.internetDownMessage));
    await tester.pump();

    expect(find.textContaining('No internet connection'), findsOneWidget);
    expect(find.byKey(const Key('pos-status-tax-settings')), findsNothing);
  });

  testWidgets('unknown status text is shown verbatim', (tester) async {
    await tester.pumpWidget(_host('Printer offline'));
    await tester.pump();
    expect(find.text('Printer offline'), findsOneWidget);
  });
}
