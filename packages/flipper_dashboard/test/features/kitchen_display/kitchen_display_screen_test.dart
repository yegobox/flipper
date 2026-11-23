import 'package:flipper_dashboard/features/kitchen_display/screens/kitchen_display_screen.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/kitchen_orders_provider.dart';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('no title bar; refresh stays and columns render', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1440, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          kitchenBranchIdProvider.overrideWithValue(null),
          kitchenOrdersStreamProvider.overrideWith(
            (ref) => Stream.value(const <KitchenOrderView>[]),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates:
              FlipperAppLocalizations.localizationsDelegates,
          supportedLocales: FlipperAppLocalizations.supportedLocales,
          home: const KitchenDisplayScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AppBar), findsNothing);
    expect(find.text('Kitchen Display'), findsNothing);
    expect(find.byTooltip('Refresh'), findsOneWidget);
    expect(find.text('Incoming'), findsOneWidget);
    expect(find.text('Ready'), findsOneWidget);
  });
}
